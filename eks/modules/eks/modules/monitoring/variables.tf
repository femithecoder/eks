variable "cluster_name" {
  type = string
}

variable "oidc_provider_arn" {
  type = string
}

variable "tags" {
  type    = map(string)
  default = {}
}

variable "loki_bucket_name" {
  type    = string
  default = "ap-dev-monitoring-logs-loki"
}

variable "loki_retention_days" {
  type    = number
  default = 30
}

variable "grafana_admin_password" {
  type    = string
  default = null
}
