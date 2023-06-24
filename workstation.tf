locals {
  network_id = "projects/${var.project_id}/global/networks/${var.vpc_name}"
  subnet_id  = "projects/${var.project_id}/regions/${var.region}/subnetworks/${var.subnetwork_name}"
  developers_email = [
  "dev1@company.com",
  "dev2@company.com",
  "dev3@company.com",
  "dev4@company.com",
  ]

  developers_name = [
  "dev1",
  "dev2",
  "dev3",
  "dev4",
  ]
}

# Creating  workstation cluster 
resource "google_workstations_workstation_cluster" "default" {
  provider               = google-beta
  project                = var.project_id
  workstation_cluster_id = "workstation-terraform"
  network                = local.network_id
  subnetwork             = local.subnet_id
  location               = var.region
}

# Creating workstation config 
resource "google_workstations_workstation_config" "default" {
  provider               = google-beta
  workstation_config_id  = "workstation-config"
  workstation_cluster_id = google_workstations_workstation_cluster.default.workstation_cluster_id
  location               = var.region
  project                = var.project_id

  host {
    gce_instance {
      machine_type                = "e2-standard-4"
      boot_disk_size_gb           = 50
      disable_public_ip_addresses = false
      service_account             = google_service_account.image-pull.email
    }
  }

  container {
    image = "someregion-docker.pkg.dev/someproject/somerepo/workstation-image:1.0"
    working_dir = "/home"
  }

  persistent_directories {
    mount_path = "/home"
    gce_pd {
      size_gb        = 200
      disk_type      = "pd-ssd"
      reclaim_policy = "DELETE"
    }
  }
}

#worksation creation
resource "google_workstations_workstation" "default" {
  provider               = google-beta
  count                  = length(local.developers_email)
  workstation_id         = "workstation-${local.developers_name[count.index]}"
  workstation_config_id  = google_workstations_workstation_config.default.workstation_config_id
  workstation_cluster_id = google_workstations_workstation_cluster.default.workstation_cluster_id
  location               = var.region
  project                = var.project_id

}

#iam permissions to access workstation i.e workstations.user
resource "google_workstations_workstation_iam_member" "member" {
  count                  = length(local.developers_email)
  provider               = google-beta
  project                = var.project_id
  location               = var.region
  workstation_cluster_id = google_workstations_workstation_cluster.default.workstation_cluster_id
  workstation_config_id  = google_workstations_workstation_config.default.workstation_config_id
  workstation_id         = "workstation-${local.developers_name[count.index]}"
  role                   = "roles/workstations.user"
  member                 = "user:${local.developers_email[count.index]}"
}