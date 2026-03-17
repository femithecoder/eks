locals {
  vpc_id                   = "vpc-09ea59a8316b56461"
  subnet_ids               = ["subnet-0cafc085a6f756ff6", "subnet-073725a2dbf57cc29", "subnet-080c85bbdc42adc98", "subnet-03b6c866bdcd57e96"]
  control_plane_subnet_ids = local.subnet_ids
}

module "eks" {
  source  = "terraform-aws-modules/eks/aws"
  version = "~> 21.0"

  name               = "gettechie-eks-cluster"
  kubernetes_version = "1.34"

  addons = {
    coredns                = {}
    eks-pod-identity-agent = {
      before_compute = true
    }
    kube-proxy             = {}
    # vpc-cni                = {
    #   before_compute = true
    #   resolve_conflicts        = "OVERWRITE"
    # }
  }

  endpoint_public_access                    = true
  enable_cluster_creator_admin_permissions = true

  vpc_id                   = local.vpc_id
  subnet_ids               = local.subnet_ids
  control_plane_subnet_ids = local.control_plane_subnet_ids

  eks_managed_node_groups = {
    gettechie = {
      ami_type       = "AL2023_x86_64_STANDARD"
      instance_types = ["c6a.xlarge"]

      min_size     = 2
      max_size     = 3
      desired_size = 2
    }
  }

  tags = var.tags
}
