output "terraform_state_bucket_name" {
  description = "Name of the Terraform state bucket."
  value       = module.cloudstorage.terraform_state_bucket_name
}

output "terraform_state_bucket_url" {
  description = "GCS URL of the Terraform state bucket."
  value       = module.cloudstorage.terraform_state_bucket_url
}

output "cloud_build_logs_bucket_name" {
  description = "Name of the Cloud Build logs bucket."
  value       = module.cloudstorage.cloud_build_logs_bucket_name
}

output "cloud_build_logs_bucket_url" {
  description = "GCS URL of the Cloud Build logs bucket."
  value       = module.cloudstorage.cloud_build_logs_bucket_url
}
