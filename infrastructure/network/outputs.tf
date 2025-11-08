output "vpc_self_link" {
  value = google_compute_network.vpc.self_link
}

output "vpc_connector_name" {
  value = google_vpc_access_connector.serverless_connector.name
}
