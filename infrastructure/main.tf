module "network" {
  source = "./network"
}

module "cloudsql" {
  source = "./cloudsql"
  vpc_self_link = module.network.vpc_self_link
  vpc_connector_name = module.network.vpc_connector_name
}

module "artifact_registry" {
  source = "./artifact_registry"
}

module "cloudrun" {
  source         = "./cloudrun"
  artifact_repo  = module.artifact_registry.repository_id
  db_password_secret_name = module.cloudsql.db_password_secret_name
  db_connection_name = module.cloudsql.postgres_connection_name
  vpc_connector_name = module.network.vpc_connector_name
}

module "frontend" {
  source             = "./frontend"
}