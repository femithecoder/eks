# variable "namespaces" {
#   type = list(string)
# }
variable "max_nodes" {
  type    = number
  default = 5
}
variable "min_nodes" {
  type    = number
  default = 2
}
variable "desired_size" {
  type    = number
  default = 2
}
## These should be removed when the switch is made to argoCD: app_state_bucket_arn, acr_secret_name

# variable "acr_secret_name" {
#   type    = string
#   default = "/azure/evity-acr-service-account"
# }
# variable "app_state_bucket_arn" {
#   type    = string
#   default = null
# }

# variable "admin_role_arns" {
#   type        = list(string)
#   description = "Admin role ARNs"
#   default     = []

# }
# variable "dev_role_arns" {
#   type        = list(string)
#   description = "Dev role ARNs"
#   default     = []
# }



# variable "poweruser_role_name" {
#   type        = string
#   description = "The name of the power user role"
#   default     = "eks-poweruser"
# }

# variable "admin_role_name" {
#   type        = string
#   description = "The name of the admin role"
#   default     = "eks-admin"

# }
variable "tags" {
  type    = map(string)
  default = {}
}

