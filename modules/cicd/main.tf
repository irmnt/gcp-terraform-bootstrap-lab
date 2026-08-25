locals {
  connection_id                    = "projects/${var.project_id}/locations/${var.region}/connections/${var.github_connection_name}"
  terraform_service_account_email  = "${var.terraform_service_account_id}@${var.project_id}.iam.gserviceaccount.com"
  terraform_service_account_name   = "projects/${var.project_id}/serviceAccounts/${local.terraform_service_account_email}"

  trigger_substitutions = {
    _BUILD_LOGS_BUCKET      = var.cloud_build_logs_bucket_name
    _ENVIRONMENT            = var.environment
    _GITHUB_CONNECTION_NAME = var.github_connection_name
    _GITHUB_REPOSITORY_NAME = var.github_repository_name
    _GITHUB_REPOSITORY_URI  = var.github_repository_uri
    _REGION                 = var.region
    _TF_SERVICE_ACCOUNT_ID  = var.terraform_service_account_id
    _TF_STATE_BUCKET        = var.terraform_state_bucket_name
  }

  trigger_included_files = [
    "cloudbuild/**",
    "env/${var.environment}/**",
    "modules/**",
  ]
}

resource "google_cloudbuildv2_repository" "repository" {
  project = var.project_id

  location          = var.region
  name              = var.github_repository_name
  parent_connection = local.connection_id
  remote_uri        = var.github_repository_uri
  deletion_policy   = "PREVENT"
}

resource "google_cloudbuild_trigger" "plan" {
  project = var.project_id

  location           = var.region
  name               = "${var.environment}-terraform-plan"
  description        = "Plans all Terraform roots for pull requests targeting main."
  filename           = "cloudbuild/plan.yaml"
  service_account    = local.terraform_service_account_name
  include_build_logs = "INCLUDE_BUILD_LOGS_WITH_STATUS"
  included_files     = local.trigger_included_files
  substitutions      = local.trigger_substitutions
  deletion_policy    = "PREVENT"

  repository_event_config {
    repository = google_cloudbuildv2_repository.repository.id

    pull_request {
      branch          = "^main$"
      comment_control = "COMMENTS_ENABLED"
    }
  }
}

resource "google_cloudbuild_trigger" "apply" {
  project = var.project_id

  location           = var.region
  name               = "${var.environment}-terraform-apply"
  description        = "Plans and applies all Terraform roots after a push to main."
  filename           = "cloudbuild/apply.yaml"
  service_account    = local.terraform_service_account_name
  include_build_logs = "INCLUDE_BUILD_LOGS_WITH_STATUS"
  included_files     = local.trigger_included_files
  substitutions      = local.trigger_substitutions
  deletion_policy    = "PREVENT"

  repository_event_config {
    repository = google_cloudbuildv2_repository.repository.id

    push {
      branch = "^main$"
    }
  }

  approval_config {
    approval_required = var.apply_requires_approval
  }
}
