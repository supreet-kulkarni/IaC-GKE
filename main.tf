module "service_account" {
  source = "./Modules/Service-Account"
  sa_name = "sa-${var.ENV_NAME}-${var.LOCATION}-${var.NUM_COUNT}"
}


module "GKE" {
  source = "./Modules/Cluster"
  cluster_name =  "gke-${var.ENV_NAME}-${var.LOCATION}-${var.NUM_COUNT}"
  location = var.LOCATION
}

module "node_pool" {
  source = "./Modules/Node-Pool"
  node_name = "node-pool-${var.ENV_NAME}-${var.NUM_COUNT}"
  cluster_name = module.GKE.cluster_name
  location = var.LOCATION
  sa_name = module.service_account.sa_email
}