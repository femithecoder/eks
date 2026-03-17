variable "name" {
  type = string
}
variable "tags" {
  type = map(string)
}
variable "allowed_dns_zone_ids" {
  type        = list(string)
  description = "DNS Zones that the SA is allowed to make records in.  This is required for ACM validation.  Fails if empty."
}
variable "environment" {
  type = string
}
variable "eks_cluster_arn" {
  type = string
}
variable "app_state_bucket_arn" {
  type    = string
  default = null
}