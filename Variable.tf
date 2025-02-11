variable "gcp_project_id" {
  description = "The ID of the GCP project"
  type        = string
}

variable "gcp_region" {
  description = "The region to deploy Cloud Run"
  type        = string
  default     = "us-central1"
}

variable "cloud_run_service_name" {
  description = "Name of the Cloud Run service"
  type        = string
  default     = "my-cloud-run-service"
}

variable "artifact_registry_name" {
  description = "Name of the Artifact Registry repository"
  type        = string
  default     = "my-repo"
}

variable "image_tag" {
  description = "The tag of the container image to deploy"
  type        = string
  default     = "latest"
}
