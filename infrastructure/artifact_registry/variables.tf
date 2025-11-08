variable "project_id" { default = "my-vote-app-4321" }
variable "region" { default = "europe-west1" }

# Variables pour Cloud Run / .env
variable "db_host" { default = "34.78.103.116" }
variable "db_user" { default = "voteuser" }
variable "db_name" { default = "voteappdb" }
variable "db_port" { default = "5432" }
