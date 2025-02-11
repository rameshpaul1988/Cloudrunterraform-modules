terraform {
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "~> 4.0"
    }
  }
}

provider "google" {
  project = var.gcp_project_id
  region  = var.gcp_region
}

# Create a service account for Cloud Run
resource "google_service_account" "cloud_run_sa" {
  account_id   = "cloud-run-sa"
  display_name = "Cloud Run Service Account"
}

# Grant Cloud Run permissions to use the service account
resource "google_project_iam_member" "cloud_run_invoker" {
  project = var.gcp_project_id
  role    = "roles/run.invoker"
  member  = "serviceAccount:${google_service_account.cloud_run_sa.email}"
}

# Deploy Cloud Run Service
resource "google_cloud_run_service" "cloud_run" {
  name     = var.cloud_run_service_name
  location = var.gcp_region
  project  = var.gcp_project_id

  template {
    spec {
      containers {
        image = "${var.gcp_region}-docker.pkg.dev/${var.gcp_project_id}/${var.artifact_registry_name}/${var.cloud_run_service_name}:${var.image_tag}"
      }
      service_account_name = google_service_account.cloud_run_sa.email
    }
  }

  traffic {
    percent         = 100
    latest_revision = true
  }
}

# IAM Binding for Cloud Run (Allow Public Access)
resource "google_cloud_run_service_iam_member" "public_access" {
  service  = google_cloud_run_service.cloud_run.name
  location = var.gcp_region
  role     = "roles/run.invoker"
  member   = "allUsers"
}

# Output Cloud Run URL
output "cloud_run_url" {
  description = "The URL of the deployed Cloud Run service"
  value       = google_cloud_run_service.cloud_run.status[0].url
}
