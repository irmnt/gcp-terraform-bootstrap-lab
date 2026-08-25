terraform {
  backend "gcs" {
    prefix = "terraform/lab/cloudstorage"
  }
}
