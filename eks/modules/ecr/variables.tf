variable "ecr_name" {
  description = "The name of the ECR repository."
  type        = string
}

variable "environment" {
  type = string
}

variable "tags" {
  type        = map(string)
  description = "Tags to apply to resources"
}

variable "image_tag_mutability" {
  description = "The mutability setting for the image tags."
  type        = string
  default     = "MUTABLE"
}

variable "scan_on_push" {
  description = "Whether to scan the image on push."
  type        = bool
  default     = true
}

variable "encryption_type" {
  description = "Encryption type for the ECR repository."
  type        = string
  default     = "AES256"
}

variable "ecrpolicy_rule_priority" {
  description = "Rule priority for the ecrpolicy."
  type        = number
  default     = 1
}

variable "ecrpolicy_description" {
  description = "Description for the ecrpolicy."
  type        = string
  default     = "Expire images older than 14 days"
}

variable "ecrpolicy_count_number" {
  description = "Number of days to retain images for the ecrpolicy."
  type        = number
  default     = 14
}

variable "keep_v_policy_rule_priority" {
  description = "Rule priority for the keep_v_prefix_images_policy."
  type        = number
  default     = 2
}

variable "keep_v_policy_description" {
  description = "Description for the keep_v_prefix_images_policy."
  type        = string
  default     = "Keep last 30 images"
}

variable "keep_v_policy_tag_prefix_list" {
  description = "List of tag prefixes to keep for the keep_v_prefix_images_policy."
  type        = list(string)
  default     = ["v"]
}

variable "keep_v_policy_count_number" {
  description = "Number of images with a specific tag to retain for the keep_v_prefix_images_policy."
  type        = number
  default     = 30
}

variable "region" {
  type = string
}