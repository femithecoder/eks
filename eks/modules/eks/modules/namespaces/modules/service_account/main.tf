locals {
  sa_secret_name  = "/service_accounts/${var.name}"
  app_secret_name = "/applications/${var.name}"
  region          = data.aws_region.current.id
}
data "aws_region" "current" {}
resource "aws_iam_user" "this" {
  name = var.name
  path = "/system/"
  tags = var.tags
}
resource "aws_iam_access_key" "this" {
  user = var.name
}
resource "aws_secretsmanager_secret" "sa" {
  name = local.sa_secret_name
}
resource "aws_secretsmanager_secret" "app" {
  name = local.app_secret_name
}
resource "aws_secretsmanager_secret_version" "sa" {
  secret_id = local.sa_secret_name
  secret_string = jsonencode({
    "id"     = aws_iam_access_key.this.id
    "secret" = aws_iam_access_key.this.secret
  })
}
data "aws_iam_policy_document" "app_state_bucket_policy" {
  count = var.app_state_bucket_arn == null ? 0 : 1
  statement {
    sid = "2"
    actions = [
      "s3:GetObject",
      "s3:PutObject",
      "s3:ListBucket",
      "s3:DeleteObject"
    ]
    resources = [
      var.app_state_bucket_arn,
      "${var.app_state_bucket_arn}/*"
    ]
    effect = "Allow"
  }
}
resource "aws_iam_policy" "app_state_bucket_policy" {
  count       = var.app_state_bucket_arn == null ? 0 : 1
  name        = "${var.name}-policy"
  path        = "/"
  description = "Read permissions for eks backend"
  policy      = data.aws_iam_policy_document.app_state_bucket_policy["0"].json
}
resource "aws_iam_user_policy_attachment" "app_state_bucket_policy" {
  count      = var.app_state_bucket_arn == null ? 0 : 1
  user       = aws_iam_user.this.id
  policy_arn = aws_iam_policy.app_state_bucket_policy["0"].arn
}
data "aws_iam_policy_document" "read_secrets_and_eks" {
  statement {
    sid = "1"
    actions = [
      "secretsmanager:GetSecretValue",
      "secretsmanager:DescribeSecret",
      "secretsmanager:GetResourcePolicy",
    ]
    resources = [
      aws_secretsmanager_secret.app.arn
    ]
    effect = "Allow"
  }
  statement {
    sid = "4"
    actions = [
      "eks:DescribeCluster"
    ]
    resources = [
      var.eks_cluster_arn
    ]
  }
}
resource "aws_iam_policy" "read_secrets_and_eks" {
  name        = "${var.name}-read-secrets"
  path        = "/"
  description = "Read permissions for secret"
  policy      = data.aws_iam_policy_document.read_secrets_and_eks.json
}
resource "aws_iam_user_policy_attachment" "read_secrets_and_eks" {
  user       = aws_iam_user.this.id
  policy_arn = aws_iam_policy.read_secrets_and_eks.arn
}
resource "aws_iam_user_policy_attachment" "create_certs" {
  user       = aws_iam_user.this.id
  policy_arn = "arn:aws:iam::aws:policy/AWSCertificateManagerFullAccess"
}
resource "aws_iam_user_policy_attachment" "read_r53" {
  user       = aws_iam_user.this.id
  policy_arn = "arn:aws:iam::aws:policy/AmazonRoute53ReadOnlyAccess"
}
data "aws_iam_policy_document" "write_r53" {
  statement {
    sid = "1"
    actions = [
      "route53:ChangeResourceRecordSets",
    ]
    resources = [
      for zone in var.allowed_dns_zone_ids : "arn:aws:route53::*:hostedzone/${zone}"
    ]
    effect = "Allow"
  }
}
resource "aws_iam_policy" "write_r53" {
  name        = "${var.name}-write-r53"
  path        = "/"
  description = "Write perms for r53"
  policy      = data.aws_iam_policy_document.write_r53.json
}
resource "aws_iam_user_policy_attachment" "write_r53" {
  user       = aws_iam_user.this.id
  policy_arn = aws_iam_policy.write_r53.arn
}
