output "terraform_service_account_email" {
  description = "Email address of the Terraform Cloud Build service account."
  value       = module.cicd.terraform_service_account_email
}

output "repository_id" {
  description = "Full resource ID of the linked Cloud Build repository."
  value       = module.cicd.repository_id
}

output "plan_trigger_id" {
  description = "ID of the pull-request plan trigger."
  value       = module.cicd.plan_trigger_id
}

output "apply_trigger_id" {
  description = "ID of the main-branch apply trigger."
  value       = module.cicd.apply_trigger_id
}

