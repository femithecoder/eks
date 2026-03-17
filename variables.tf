variable "environment" {
  type    = string
  default = "dev"
}
variable "region" {
  type    = string
  default = "eu-west-2"
}
variable "eks_cluster_version" {
  type    = string
  default = "1.34"
}
# variable "eks_system_masters" {
#   type    = list(string)
#   default = []
# }
variable "max_nodes" {
  type    = number
  default = 5
}
variable "min_nodes" {
  type    = number
  default = 1
}

variable "desired_size" {
  type    = number
  default = 2
}

