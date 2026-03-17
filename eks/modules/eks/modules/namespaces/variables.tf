variable "name" {
  type = string
}
variable "environment" {
  type = string
}
variable "tags" {
  type = map(string)
}
variable "allowed_dns_zone_ids" {
  type = list(string)
}
variable "eks_cluster_arn" {
  type = string
}
## These should be removed when the switch is made to argoCD: app_state_bucket_arn, acr_secret_name
variable "app_state_bucket_arn" {
  type    = string
  default = null
}
variable "acr_secret_name" {
  type    = string
  default = "/azure/evity-acr-service-account"
}