variable "project_id" { default = "my-vote-app-4321" }
variable "region" { default = "europe-west1" }
variable "artifact_repo" { default     = "voteapp-repo" }
variable "db_password_secret_name" { type = string }
variable "db_connection_name" { type = string }
variable "vpc_connector_name" { type = string }
