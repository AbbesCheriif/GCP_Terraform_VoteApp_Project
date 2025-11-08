resource "random_password" "db_password" {
  length  = 20
  override_special = "!@#"
}

resource "google_sql_database_instance" "postgres" {
  name             = "vote-postgres"
  database_version = "POSTGRES_15"
  region           = var.region

  settings {
    tier = "db-f1-micro"
    ip_configuration {
      ipv4_enabled    = false
      private_network = var.vpc_self_link      
    }
  }
  deletion_protection = false
  # Ajoute cette ligne pour attendre que le peering soit créé
  depends_on = [var.vpc_connector_name]
}

resource "google_sql_database" "appdb" {
  name     = "voteappdb"
  instance = google_sql_database_instance.postgres.name
}

resource "google_sql_user" "dbuser" {
  name     = "voteuser"
  instance = google_sql_database_instance.postgres.name
  password = random_password.db_password.result
}

resource "google_secret_manager_secret" "db_password_secret" {
  secret_id = "vote-db-password"
  replication {
    auto {}
  }
}


resource "google_secret_manager_secret_version" "db_secret_version" {
  secret      = google_secret_manager_secret.db_password_secret.id
  secret_data = random_password.db_password.result
}


output "db_password_secret_name" {
  value = google_secret_manager_secret.db_password_secret.secret_id
}