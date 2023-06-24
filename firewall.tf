resource "google_compute_firewall" "workstation-egress" {
  name    = "workstation-internal-egress"
  network = var.vpc_name
  project = var.project_id

  allow {
    protocol = "tcp"
    ports    = ["980", "443"]
  }

  priority    = "10"
  direction   = "EGRESS"
  target_tags = ["cloud-workstations-instance"]
}

#workstation internal ingress
resource "google_compute_firewall" "workstation-ingress" {
  name    = "workstation-internal-ingress"
  network = var.vpc_name
  project = var.project_id

  allow {
    protocol = "icmp"
  }

  allow {
    protocol = "tcp"
    ports    = ["0-65535"]
  }

  allow {
    protocol = "udp"
    ports    = ["0-65535"]
  }

  target_tags   = []
  source_ranges = [var.subnet_range] 
  direction     = "INGRESS"
  priority      = "20"
}