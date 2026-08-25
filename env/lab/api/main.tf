module "api" {
  source = "../../../modules/api"

  project_id = var.project_id
  services   = var.services
}

