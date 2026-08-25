terraform {
  backend "gcs" {
    prefix = "terraform/lab/api"
  }
}
