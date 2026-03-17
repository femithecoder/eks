variable "create_admin_role" {
  description = "Whether to create an admin role"
  type        = bool
  default     = true
}

variable "allow_self_assume_role" {
  description = "Allows roles to assume themselves"
  type        = bool
  default     = true
}

variable "create_poweruser_role" {
  description = "Whether to create a power user role"
  type        = bool
  default     = true
}

variable "admin_role_name" {
  description = "The name of the admin role"
  type        = string
}

variable "poweruser_role_name" {
  description = "The name of the power user role"
  type        = string
}

variable "readonly_role_name" {
  description = "The name of the readonly role"
  type        = string
  default     = null
}

variable "create_readonly_role" {
  description = "Whether to create a readonly role"
  type        = bool
  default     = false
}
variable "max_session_duration" {
  description = "Maximum CLI/API session duration in seconds between 3600 and 43200"
  type        = number
  default     = 43200
}