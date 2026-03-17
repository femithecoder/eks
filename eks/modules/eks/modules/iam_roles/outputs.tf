output "admin_role_arn" {
  description = "ARN of the admin role created"
  value       = module.iam_assumable_roles_with_saml.admin_iam_role_arn
}
output "poweruser_role_arn" {
  description = "ARN of the poweruser role created"
  value       = module.iam_assumable_roles_with_saml.poweruser_iam_role_arn
}

