module "cicd" {
  source = "../../../modules/cicd"

  project_id                      = var.project_id
  environment                     = var.environment
  region                          = var.region
  github_connection_name          = var.github_connection_name
  github_repository_name          = var.github_repository_name
  github_repository_uri           = var.github_repository_uri
  terraform_service_account_id    = var.terraform_service_account_id
  terraform_service_account_roles = var.terraform_service_account_roles
  terraform_state_bucket_name     = var.terraform_state_bucket_name
  cloud_build_logs_bucket_name    = var.cloud_build_logs_bucket_name
  apply_requires_approval         = var.apply_requires_approval
}

