resource "google_container_node_pool" "node_pool" {
  name       = var.node_name
  location   = var.location
  cluster    = var.cluster_name
  initial_node_count = 1

 autoscaling {
   location_policy = "BALANCED"
   max_node_count = 3
   min_node_count = 0
 }

  node_config {
    preemptible  = true
    machine_type = "e2-standard-2"
    # service_account = var.node_name
    # oauth_scopes = [
    #    "https://www.googleapis.com/auth/cloud-platform"
    # ]
  }
}