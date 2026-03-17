variable "zone_name" {
  type        = string
  description = "Name of Zone"
}

variable "tags" {
  type        = map(string)
  description = "Tags to apply to resources"
}