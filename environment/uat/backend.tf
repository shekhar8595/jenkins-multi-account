terraform {
  backend "gcs" {
    bucket  = "spheric-terraform-state-bucket"
    prefix  = "uat"
  }
}