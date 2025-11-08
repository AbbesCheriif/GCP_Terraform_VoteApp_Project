# Plage IP privée pour Cloud SQL
resource "google_compute_global_address" "cloudsql_private_ip_range" {
  name          = "cloudsql-private-ip-range"
  purpose       = "VPC_PEERING"
  address_type  = "INTERNAL"
  prefix_length = 16
  network       = google_compute_network.vpc.id
}


resource "google_compute_network" "vpc" {
  name                    = "voteapp-vpc"
  auto_create_subnetworks = true
}


# VPC Connector pour Cloud Run
resource "google_vpc_access_connector" "serverless_connector" {
  name          = "voteapp-vpc-connector"
  region        = var.region
  network       = google_compute_network.vpc.name
  ip_cidr_range = "10.8.0.0/28"
  min_throughput = 200  # Mbps
  max_throughput = 400  # Mbps
}


# Peering entre ton VPC et Cloud SQL
resource "google_service_networking_connection" "private_vpc" {
  network                 = google_compute_network.vpc.id
  service                 = "servicenetworking.googleapis.com"
  reserved_peering_ranges = [google_compute_global_address.cloudsql_private_ip_range.name]
}
