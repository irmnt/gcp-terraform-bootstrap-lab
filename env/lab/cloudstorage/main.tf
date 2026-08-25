module "cloudstorage" {
  source = "../../../modules/cloudstorage"

  project_id                     = var.project_id
  environment                    = var.environment
  location                       = var.location
  terraform_state_bucket_name    = var.terraform_state_bucket_name
  cloud_build_logs_bucket_name   = var.cloud_build_logs_bucket_name
  cloud_build_log_lifecycle_days = var.cloud_build_log_lifecycle_days
}

