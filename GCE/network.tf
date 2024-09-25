# 建立 VPC
resource "google_compute_network" "terraform_network" {
  name                    = "terraform-vpc-network"
  auto_create_subnetworks = true
}