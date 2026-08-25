output "terraform_service_account_email" {
  description = "Email address of the Terraform Cloud Build service account."
  value       = google_service_account.terraform.email
}

output "repository_id" {
  description = "Full resource ID of the linked Cloud Build repository."
  value       = google_cloudbuildv2_repository.repository.id
}

output "plan_trigger_id" {
  description = "ID of the pull-request plan trigger."
  value       = google_cloudbuild_trigger.plan.trigger_id
}

output "apply_trigger_id" {
  description = "ID of the main-branch apply trigger."
  value       = google_cloudbuild_trigger.apply.trigger_id
}
