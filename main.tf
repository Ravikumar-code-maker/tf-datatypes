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

############################
# Cloud Storage Bucket
############################
resource "google_storage_bucket" "bucket" {
  name          = var.env_config[var.environment].bucket_name
  force_destroy = true
}
############################
# API Gateway
############################
resource "google_api_gateway_api" "api" {
  api_id = "${var.environment}-api"
}

resource "google_api_gateway_api_config" "api_config" {
  api           = google_api_gateway_api.api.api_id
  api_config_id = "${var.environment}-config"

  openapi_documents {
    documents {
      path      = "openapi.yaml"
      contents  = filebase64("openapi.yaml")
    }
  }
}

resource "google_api_gateway_gateway" "gateway" {
  name       = "${var.environment}-gateway"
  api_config = google_api_gateway_api_config.api_config.id
  region     = var.region
}

