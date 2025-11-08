# Cloud Run deployment for vote-app

resource "google_service_account" "cloud_run_sa" {
  account_id   = "voteapp-cloudrun-sa"
  display_name = "Cloud Run Service Account for Vote App"
}

# Donner les droits nécessaires à Cloud Run pour accéder à Secret Manager et Cloud SQL
resource "google_project_iam_member" "run_secret_access" {
  role   = "roles/secretmanager.secretAccessor"
  member = "serviceAccount:${google_service_account.cloud_run_sa.email}"
  project = var.project_id
}

resource "google_project_iam_member" "run_sql_access" {
  role   = "roles/cloudsql.client"
  member = "serviceAccount:${google_service_account.cloud_run_sa.email}"
  project = var.project_id
}

# Déploiement Cloud Run
resource "google_cloud_run_service" "voteapp_service" {
  name     = "vote-app"
  location = var.region

  template {

    metadata {
      annotations = {
        "run.googleapis.com/vpc-access-connector" = var.vpc_connector_name
        "run.googleapis.com/vpc-access-egress"    = "all"
        "run.googleapis.com/cloudsql-instances"  = var.db_connection_name
      }
    } 

    spec {
      service_account_name = google_service_account.cloud_run_sa.email

      containers {
        image = "${var.region}-docker.pkg.dev/${var.project_id}/${var.artifact_repo}/vote-app:latest"

        env {
          name  = "DB_HOST"
          value = var.db_connection_name
          #value = "34.78.103.116"
        }

        env {
          name  = "DB_USER"
          value = "voteuser"
        }

        env {
          name  = "DB_NAME"
          value = "voteappdb"
        }

        env {
          name  = "DB_PORT"
          value = "5432"
        }

        # Récupération du mot de passe depuis Secret Manager
        env {
          name = "DB_PASSWORD"
          value_from {
            secret_key_ref {
              name = var.db_password_secret_name
              key  = "latest"
            }
          }
        }

        ports {
          container_port = 8080
        }
        
      }
    }
  }

  traffic {
    percent         = 100
    latest_revision = true
  }

  autogenerate_revision_name = true
}

# Rendre le service public
resource "google_cloud_run_service_iam_member" "public_access" {
  service  = google_cloud_run_service.voteapp_service.name
  location = var.region
  role     = "roles/run.invoker"
  member   = "allUsers"
}
