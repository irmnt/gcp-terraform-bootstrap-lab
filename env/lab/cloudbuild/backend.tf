terraform {
  backend "gcs" {
    prefix = "terraform/lab/cloudbuild"
  }
}

