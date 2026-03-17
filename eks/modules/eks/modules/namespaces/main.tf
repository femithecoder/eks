locals {
  region = data.aws_region.current.id
}
data "aws_secretsmanager_secret" "acr" {
  name = var.acr_secret_name
}
data "aws_secretsmanager_secret_version" "acr_latest" {
  secret_id = data.aws_secretsmanager_secret.acr.id
}
data "aws_region" "current" {}
module "service_account" {
  source               = "./modules/service_account"
  name                 = var.name
  allowed_dns_zone_ids = var.allowed_dns_zone_ids
  environment          = var.environment
  eks_cluster_arn      = var.eks_cluster_arn
  # This should be removed when the migration to argoCD is complete since you won't be using an app_state_bucket anymore
  app_state_bucket_arn = var.app_state_bucket_arn
  tags                 = var.tags
}
resource "kubernetes_namespace" "ns" {
  metadata {
    annotations = {
      name = var.name
    }
    name = var.name
  }
}
resource "kubernetes_secret" "acr" {
  metadata {
    name      = "acr"
    namespace = var.name
  }
  type = "kubernetes.io/dockerconfigjson"
  data = {
    ".dockerconfigjson" = jsonencode({
      auths = {
        "${jsondecode(data.aws_secretsmanager_secret_version.acr_latest.secret_string).registry_server}" = {
          "username" = jsondecode(data.aws_secretsmanager_secret_version.acr_latest.secret_string).user
          "password" = jsondecode(data.aws_secretsmanager_secret_version.acr_latest.secret_string).pass
          "email"    = ""
          "auth"     = base64encode("${jsondecode(data.aws_secretsmanager_secret_version.acr_latest.secret_string).user}:${jsondecode(data.aws_secretsmanager_secret_version.acr_latest.secret_string).pass}")
        }
      }
    })
  }
}
