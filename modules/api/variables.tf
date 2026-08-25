variable "project_id" {
  description = "The personal GCP project ID used by the lab."
  type        = string

  validation {
    condition     = length(trimspace(var.project_id)) > 0
    error_message = "project_id must not be empty."
  }
}

variable "services" {
  description = "Google Cloud APIs managed by this module."
  type        = set(string)

  validation {
    condition     = length(var.services) > 0 && alltrue([for service in var.services : endswith(service, ".googleapis.com")])
    error_message = "services must contain at least one valid googleapis.com service name."
  }
}

