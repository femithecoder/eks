locals {
  namespace             = "monitoring"
  loki_service_account  = "loki"
  grafana_admin_password = var.grafana_admin_password != null ? var.grafana_admin_password : random_password.grafana[0].result
}

data "aws_region" "current" {}

resource "kubernetes_namespace" "monitoring" {
  metadata {
    name = local.namespace
  }
}

resource "aws_s3_bucket" "loki_logs" {
  bucket = var.loki_bucket_name
  tags   = merge(var.tags, { "Name" = "${var.cluster_name}-loki-logs" })
}

resource "aws_s3_bucket_public_access_block" "loki_logs" {
  bucket = aws_s3_bucket.loki_logs.id

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

resource "aws_s3_bucket_lifecycle_configuration" "loki_logs" {
  bucket = aws_s3_bucket.loki_logs.id

  rule {
    id     = "retention"
    status = "Enabled"

    filter {}

    expiration {
      days = var.loki_retention_days
    }
  }
}

data "aws_iam_policy_document" "loki_s3" {
  statement {
    sid    = "BucketAccess"
    effect = "Allow"

    actions = [
      "s3:ListBucket",
      "s3:GetBucketLocation"
    ]

    resources = [aws_s3_bucket.loki_logs.arn]
  }

  statement {
    sid    = "ObjectAccess"
    effect = "Allow"

    actions = [
      "s3:PutObject",
      "s3:GetObject",
      "s3:DeleteObject",
      "s3:AbortMultipartUpload",
      "s3:ListMultipartUploadParts",
      "s3:ListMultipartUploads"
    ]

    resources = ["${aws_s3_bucket.loki_logs.arn}/*"]
  }
}

resource "aws_iam_policy" "loki_s3" {
  name   = "${var.cluster_name}-loki-s3"
  policy = data.aws_iam_policy_document.loki_s3.json
}

module "loki_iam_role" {
  source          = "terraform-aws-modules/iam/aws//modules/iam-role-for-service-accounts"
  name            = "${var.cluster_name}-loki"
  use_name_prefix = false

  policies = {
    loki = aws_iam_policy.loki_s3.arn
  }

  oidc_providers = {
    one = {
      provider_arn               = var.oidc_provider_arn
      namespace_service_accounts = ["${local.namespace}:${local.loki_service_account}"]
    }
  }
}

resource "kubernetes_service_account" "loki" {
  metadata {
    name      = local.loki_service_account
    namespace = local.namespace
    annotations = {
      "eks.amazonaws.com/role-arn" = module.loki_iam_role.arn
    }
  }
}

resource "random_password" "grafana" {
  count   = var.grafana_admin_password == null ? 1 : 0
  length  = 20
  special = false
}

resource "helm_release" "loki_stack" {
  name       = "loki"
  repository = "https://grafana.github.io/helm-charts"
  chart      = "loki-stack"
  namespace  = local.namespace

  values = [templatefile("${path.module}/templates/loki-stack-values.yaml.tmpl", {
    loki_service_account   = local.loki_service_account
    bucket_name            = var.loki_bucket_name
    region                 = data.aws_region.current.id
    retention_period       = "${var.loki_retention_days * 24}h"
    grafana_admin_password = local.grafana_admin_password
  })]

  depends_on = [
    kubernetes_namespace.monitoring,
    kubernetes_service_account.loki
  ]
}
