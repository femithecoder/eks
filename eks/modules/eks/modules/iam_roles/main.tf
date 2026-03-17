# IAM assumable roles with SAML
module "iam_assumable_roles_with_saml" {
  source = "git::https://github.com/terraform-aws-modules/terraform-aws-iam.git//modules/iam-assumable-roles-with-saml"

  create_admin_role      = var.create_admin_role
  allow_self_assume_role = var.allow_self_assume_role
  create_poweruser_role  = var.create_poweruser_role
  admin_role_name        = var.admin_role_name
  poweruser_role_name    = var.poweruser_role_name
  readonly_role_name     = var.readonly_role_name
  create_readonly_role   = var.create_readonly_role
  max_session_duration   = var.max_session_duration
}
