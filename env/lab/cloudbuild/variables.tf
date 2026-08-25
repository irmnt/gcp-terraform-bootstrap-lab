variable "project_id" {
  description = "The personal GCP project ID used by the lab."
  type        = string

  validation {
    condition     = length(trimspace(var.project_id)) > 0
    error_message = "project_id must not be empty."
  }
}

variable "environment" {
  description = "Short environment name used in trigger names."
  type        = string
  default     = "lab"
}

variable "region" {
  description = "Region shared by the Cloud Build connection, repository, and triggers."
  type        = string
}

variable "github_connection_name" {
  description = "Name of the manually created Cloud Build GitHub connection."
  type        = string
}

variable "github_repository_name" {
  description = "Name assigned to the linked Cloud Build repository."
  type        = string
}

variable "github_repository_uri" {
  description = "HTTPS clone URI of the personal GitHub repository."
  type        = string
}

variable "terraform_service_account_id" {
  description = "Account ID of the service account used by Cloud Build."
  type        = string
  default     = "terraform-cloud-build"
}

variable "terraform_service_account_roles" {
  description = "Project-level roles granted to the Terraform Cloud Build service account."
  type        = set(string)
  default = [
    "roles/cloudbuild.editor",
    "roles/iam.securityReviewer",
    "roles/iam.serviceAccountViewer",
    "roles/serviceusage.serviceUsageAdmin",
    "roles/storage.admin",
  ]
}

variable "terraform_state_bucket_name" {
  description = "Name of the GCS bucket used for Terraform state."
  type        = string
}

variable "cloud_build_logs_bucket_name" {
  description = "Name of the GCS bucket used for Cloud Build logs."
  type        = string
}

variable "apply_requires_approval" {
  description = "Require manual approval before an apply-triggered build starts."
  type        = bool
  default     = true
}

