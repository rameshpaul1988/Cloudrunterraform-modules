output "cloud_run_urls" {
  description = "URLs of deployed Cloud Run services"
  value       = { for key, service in google_cloud_run_service.cloud_run : key => service.status[0].url }
}

output "cloud_run_service_accounts" {
  description = "The service account used by Cloud Run services"
  value       = google_service_account.cloud_run_sa.email
}
