terraform {
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "7.28.0"
    }
  }

  backend "gcs" {
  bucket  = "cloud-works-terraform-state-bucket"
  prefix  = "gke/dev"
}
}

provider "google" {
  project     = var.PROJECT_ID
  region      = var.LOCATION
}

