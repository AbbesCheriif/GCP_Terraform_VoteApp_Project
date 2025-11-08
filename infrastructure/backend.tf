terraform {
  required_version = ">= 1.3"
  backend "gcs" {
    bucket = "terraform-state-my-vote-app-4321"
    prefix = "terraform/state"
  }
}