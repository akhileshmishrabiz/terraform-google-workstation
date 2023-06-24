resource "google_artifact_registry_repository" "workstation-repo" {
  project       = var.project_id
  location      = var.region
  repository_id = var.artifact_repo
  format        = "DOCKER"
}