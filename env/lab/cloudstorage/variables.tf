variable "project_id" {
  description = "The personal GCP project ID used by the lab."
  type        = string

  validation {
    condition     = length(trimspace(var.project_id)) > 0
    error_message = "project_id must not be empty."
  }
}

variable "environment" {
  description = "Short environment name used in labels."
  type        = string
  default     = "lab"
}

variable "location" {
  description = "Cloud Storage location for both buckets."
  type        = string
}

variable "terraform_state_bucket_name" {
  description = "Globally unique name of the Terraform state bucket."
  type        = string
}

variable "cloud_build_logs_bucket_name" {
  description = "Globally unique name of the Cloud Build logs bucket."
  type        = string
}

variable "cloud_build_log_lifecycle_days" {
  description = "Number of days after which Cloud Build log objects are deleted."
  type        = number
  default     = 30
}
