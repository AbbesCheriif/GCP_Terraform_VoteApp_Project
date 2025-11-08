# Bucket pour héberger le frontend
resource "google_storage_bucket" "frontend_bucket" {
  name          = "${var.project_id}-frontend-bucket"
  location      = var.region
  force_destroy = true

  website {
    main_page_suffix = "index.html"
    not_found_page   = "index.html"
  }

  uniform_bucket_level_access = true
}

# Upload des fichiers Angular
resource "google_storage_bucket_object" "frontend_files" {
  for_each = { for f in fileset("C:/Vote_App_Golang/Frontend/vote_frontend/dist/vote_frontend/browser", "**") : f => f }

  name   = each.value
  bucket = google_storage_bucket.frontend_bucket.name
  source = "C:/Vote_App_Golang/Frontend/vote_frontend/dist/vote_frontend/browser/${each.value}"

  content_type = lookup({
    "html"  = "text/html"
    "css"   = "text/css"
    "js"    = "application/javascript"
    "ico"   = "image/x-icon"
    "json"  = "application/json"
    "png"   = "image/png"
    "svg"   = "image/svg+xml"
  }, lower(regex("\\.([^.]+)$", each.value)[0]), "application/octet-stream")

  cache_control = contains([
    "index.html",
    "index.csr.html",
    "favicon.ico" 
    ], each.value) ? "no-cache, max-age=0" : "public, max-age=31536000, immutable"

}


# Rendre le bucket public pour permettre l'accès aux fichiers
resource "google_storage_bucket_iam_member" "public_access" {
  bucket = google_storage_bucket.frontend_bucket.name
  role   = "roles/storage.objectViewer"
  member = "allUsers"
}
