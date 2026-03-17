locals {
  region       = var.region
  client       = "gettechie-infra"
  environment  = var.environment
  name         = "${local.client}-${local.environment}"
  organization = "gettechie"
  tags = {
    "Environment" = local.environment
    "Client"      = local.client
    "name"        = "gettechie"
  }
}

data "aws_region" "current" {}

module "eks" {
  source = "../../modules/eks"
  tags   = local.tags
}

data "aws_route53_zone" "selected" {
  name         = "gettechiechallenge.com"
  private_zone = false
}

module "ebs_csi_driver" {
  source            = "../../modules/eks/modules/ebs_csi_driver"
  cluster_name      = module.eks.cluster_name
  oidc_provider_arn = module.eks.oidc_provider_arn

  providers = {
    kubernetes = kubernetes
    helm       = helm
  }

  depends_on = [module.eks]
}

module "aws_load_balancer_controller" {
  source            = "../../modules/eks/modules/aws_load_balancer_controller"
  cluster_name      = module.eks.cluster_name
  oidc_provider_arn = module.eks.oidc_provider_arn
  domain_name       = data.aws_route53_zone.selected.name
  r53_zone_id       = data.aws_route53_zone.selected.zone_id
  tags              = local.tags
  region            = data.aws_region.current.id
  vpc_id            = module.eks.vpc_id

  providers = {
    kubernetes = kubernetes
    helm       = helm
  }

  depends_on = [module.eks, data.aws_route53_zone.selected]
}

module "external_dns" {
  source            = "../../modules/eks/modules/external_dns"
  cluster_name      = module.eks.cluster_name
  oidc_provider_arn = module.eks.oidc_provider_arn

  providers = {
    kubernetes = kubernetes
    helm       = helm
  }

  depends_on = [module.eks]
}

# module "monitoring" {
#   source            = "../../modules/eks/modules/monitoring"
#   cluster_name      = module.eks.cluster_name
#   oidc_provider_arn = module.eks.oidc_provider_arn
#   tags              = local.tags

#   providers = {
#     kubernetes = kubernetes
#     helm       = helm
#   }

#   depends_on = [module.eks]
# }


