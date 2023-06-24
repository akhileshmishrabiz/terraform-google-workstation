resource "google_project_service" "api" {
  for_each = toset([
    "workstations.googleapis.com",
    "artifactregistry.googleapis.com",
  ])
  service            = each.value
  disable_on_destroy = false
}