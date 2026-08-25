variable "project_id" {
  description = "The personal GCP project ID used by the lab."
  type        = string

  validation {
    condition     = length(trimspace(var.project_id)) > 0
    error_message = "project_id must not be empty."
  }
}

variable "environment" {
  description = "Short environment name used by the lab."
  type        = string
  default     = "lab"
}

variable "services" {
  description = "Google Cloud APIs managed by this root."
  type        = set(string)
  default = [
    "cloudbuild.googleapis.com",
    "cloudresourcemanager.googleapis.com",
    "iam.googleapis.com",
    "secretmanager.googleapis.com",
    "serviceusage.googleapis.com",
    "storage.googleapis.com",
  ]
}
