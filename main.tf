terraform {
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "7.14.1"
    }
  }
}

provider "google" {
  # Configuration options
  project = "main-nucleus-418523"
  region  = "us-central1"
}


terraform {
  backend "gcs" {
    bucket = "terraform-lock-buckettt"
    prefix = "terraform/state"
  }
}



resource "google_compute_address" "static" {
  name = "ipv4-address"
}

data "google_compute_image" "debian_image" {
  family  = "debian-11"
  project = "debian-cloud"
}

resource "google_compute_instance" "instance_with_ip" {
  name         = "vm-instance"
  machine_type = "f1-micro"
  zone         = "us-central1-a"

  boot_disk {
    initialize_params {
      image = data.google_compute_image.debian_image.self_link
    }
  }

  network_interface {
    network = "default"
    access_config {
      nat_ip = google_compute_address.static.address
    }
  }
}
