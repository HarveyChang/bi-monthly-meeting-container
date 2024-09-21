# 建立 VPC
resource "google_compute_network" "docker_network" {
  name                    = "docker-vpc-network"
  auto_create_subnetworks = true
}