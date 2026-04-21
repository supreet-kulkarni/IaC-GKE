resource "google_service_account" "sa" {
  account_id   = var.sa_name
  display_name = var.sa_name
}