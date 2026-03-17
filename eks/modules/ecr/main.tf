provider "aws" {
  region = var.region
}
resource "aws_ecr_repository" "ecr" {
  name                 = var.ecr_name
  image_tag_mutability = var.image_tag_mutability
  tags                 = var.tags

  image_scanning_configuration {
    scan_on_push = var.scan_on_push
  }

  encryption_configuration {
    encryption_type = var.encryption_type
  }
}

resource "aws_ecr_lifecycle_policy" "ecrpolicy" {
  repository = aws_ecr_repository.ecr.name

  policy = jsonencode({
    rules = [
      {
        rulePriority = var.ecrpolicy_rule_priority,
        description  = var.ecrpolicy_description,
        selection = {
          tagStatus   = "untagged",
          countType   = "sinceImagePushed",
          countUnit   = "days",
          countNumber = var.ecrpolicy_count_number
        },
        action = {
          type = "expire"
        }
      }
    ]
  })
}

resource "aws_ecr_lifecycle_policy" "keep_v_prefix_images_policy" {
  repository = aws_ecr_repository.ecr.name

  policy = jsonencode({
    rules = [
      {
        rulePriority = var.keep_v_policy_rule_priority,
        description  = var.keep_v_policy_description,
        selection = {
          tagStatus     = "tagged",
          tagPrefixList = var.keep_v_policy_tag_prefix_list,
          countType     = "imageCountMoreThan",
          countNumber   = var.keep_v_policy_count_number
        },
        action = {
          type = "expire"
        }
      }
    ]
  })
}
