# To pull image for workstation
resource "google_service_account" "image-pull" {
  project      = var.project_id
  account_id   = "image-pull"
  display_name = "Service Account - container image pull"
}

resource "google_project_iam_member" "workstation-image" {
  project = var.project_id
  role    = "roles/artifactregistry.reader"
  member  = "serviceAccount:${google_service_account.image-pull.email}"
}