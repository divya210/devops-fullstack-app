## 1. authentication credentials
provider "google" {
  credentials = "/Users/divya/Downloads/nifty-linker-426206-t3-f8b69eda7e70.json"
  project     = "nifty-linker-426206-t3"
  region      = "us-east1"
}

## 2. vpc creation process
resource "google_compute_network" "vpc_network" {
  name                    = "techverito-vpc-network"
  auto_create_subnetworks = false
}

resource "google_compute_subnetwork" "subnet1" {
  name          = "subnet-1"
  ip_cidr_range = "10.10.0.1/26"
  region        = "us-east1"
  network       = google_compute_network.vpc_network.id
}

resource "google_compute_subnetwork" "subnet2" {
  name          = "subnet-2"
  ip_cidr_range = "10.10.0.64/26"
  region        = "us-east1"
  network       = google_compute_network.vpc_network.id
}

## 3. database creation
resource "google_sql_database_instance" "postgres_instance" {
  name             = "techveroti-postgres"
  database_version = "POSTGRES_15"
  region           = "us-east1"

  settings {
    tier = "db-f1-micro" # Change to the desired machine type

    ip_configuration {
      ipv4_enabled    = true
      private_network = google_compute_network.vpc_network.id
    }
  }
}

resource "google_sql_database" "postgres_db" {
  name     = "techverito-database"
  instance = google_sql_database_instance.postgres_instance.name
}

resource "google_sql_user" "users" {
  name     = "postgres"
  instance = google_sql_database_instance.postgres_instance.name
  password = "Asdfg@7890" 
}

## 4. K8s cluster