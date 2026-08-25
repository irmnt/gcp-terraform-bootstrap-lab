output "enabled_services" {
  description = "Google Cloud APIs managed by Terraform."
  value       = sort([for service in google_project_service.service : service.service])
}

