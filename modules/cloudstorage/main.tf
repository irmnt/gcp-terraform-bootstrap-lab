locals {
  common_labels = merge(
    var.labels,
    {
      environment = var.environment
      managed-by  = "terraform"
      purpose     = "bootstrap-lab"
    }
  )
}

resource "google_storage_bucket" "terraform_state" {
  project = var.project_id
  name    = var.terraform_state_bucket_name

  location                    = var.location
  storage_class               = "STANDARD"
  force_destroy               = false
  public_access_prevention    = "enforced"
  uniform_bucket_level_access = true
  labels                      = local.common_labels

  versioning {
    enabled = true
  }

  lifecycle {
    prevent_destroy = true
  }
}

resource "google_storage_bucket" "cloud_build_logs" {
  project = var.project_id
  name    = var.cloud_build_logs_bucket_name

  location                    = var.location
  storage_class               = "STANDARD"
  force_destroy               = false
  public_access_prevention    = "enforced"
  uniform_bucket_level_access = true
  labels                      = local.common_labels

  lifecycle_rule {
    action {
      type = "Delete"
    }

    condition {
      age = var.cloud_build_log_lifecycle_days
    }
  }

  lifecycle {
    prevent_destroy = true
  }
}
