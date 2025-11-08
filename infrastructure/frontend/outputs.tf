output "frontend_bucket_name" {
  value = google_storage_bucket.frontend_bucket.name
}

output "frontend_url" {
  value = "https://storage.googleapis.com/${google_storage_bucket.frontend_bucket.name}/index.html"
}
