############################
# VPC
############################
resource "google_compute_network" "vpc" {
  name                    = "${var.environment}-vpc"
  auto_create_subnetworks = false
}

############################
# Subnet
############################
resource "google_compute_subnetwork" "subnet" {
  name          = "${var.environment}-subnet"
  ip_cidr_range = "10.0.1.0/24"
  region        = var.region
  network       = google_compute_network.vpc.id
}
############################
# Route
############################
resource "google_compute_route" "default_route" {
  name             = "${var.environment}-route"
  network          = google_compute_network.vpc.name
  dest_range       = "0.0.0.0/0"
  next_hop_gateway = "default-internet-fateway"
}

############################
# VM Instance
############################
resource "google_compute_instance" "vm" {
  name         = "${var.environment}-vm"
  machine_type = var.env_config[var.environment].machine_type
  zone         = "${var.region}-a"

  boot_disk {
    initialize_params {
      image  = "debian-cloud/debian-11"
    }
  }
  network_interface {
    subnetwork = google_compute_network.subnet.id
    access_config {}
  }
}


