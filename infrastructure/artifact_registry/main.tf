# Artifact Registry - dépôt Docker backend


resource "google_artifact_registry_repository" "voteapp_repo" {
  provider = google
  location = var.region
  repository_id = "voteapp-repo"
  description = "Docker repository for Vote App backend"
  format = "DOCKER"
}



# Construction et push de l'image backend

# On utilise une étape local-exec pour construire et pousser depuis ta machine
resource "null_resource" "build_and_push_backend_image" {
  provisioner "local-exec" {
    command = <<EOT
      cd ../Backend
      # Création d'un fichier .env temporaire pour Docker (sans le mot de passe)
      echo "DB_HOST=${var.db_host}" > .env.tmp
      echo "DB_USER=${var.db_user}" >> .env.tmp
      echo "DB_NAME=${var.db_name}" >> .env.tmp
      echo "DB_PORT=${var.db_port}" >> .env.tmp

      # Build de l'image
      docker build --build-arg DB_HOST=${var.db_host} \
                   --build-arg DB_USER=${var.db_user} \
                   --build-arg DB_NAME=${var.db_name} \
                   --build-arg DB_PORT=${var.db_port} \
                   -t ${var.region}-docker.pkg.dev/${var.project_id}/${google_artifact_registry_repository.voteapp_repo.repository_id}/vote-app:latest .

      # Push vers Artifact Registry
      docker push ${var.region}-docker.pkg.dev/${var.project_id}/${google_artifact_registry_repository.voteapp_repo.repository_id}/vote-app:latest

      # Supprimer le fichier temporaire
      rm .env.tmp
    EOT
  }

  depends_on = [google_artifact_registry_repository.voteapp_repo]
}

# passer l'id de l'artifact_repo depuis vers le module enfant (cloudrun)
output "repository_id" {
  value = google_artifact_registry_repository.voteapp_repo.repository_id
}