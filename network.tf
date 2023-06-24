resource "google_compute_network" "main-vpc" {
  name                    = var.vpc_name
  auto_create_subnetworks = false
  project                 = var.project_id
}

resource "google_compute_subnetwork" "main-subnet" {
  name                     = var.subnetwork_name
  ip_cidr_range       = var.subnetwork_range
  region                    = var.region
  project                   = var.project_id
  network                 = google_compute_network.main-vpc.name
  private_ip_google_access = true
}