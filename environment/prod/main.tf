provider "google" {
  project = var.project_id
  region  = var.region
}

module "vm" {
  source        = "../../modules/vm"
  instance_name = var.instance_name
  machine_type  = var.machine_type
  zone          = var.zone
  tags          = var.tags
}
