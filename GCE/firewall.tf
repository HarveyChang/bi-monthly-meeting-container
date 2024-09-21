resource "google_compute_firewall" "allow_all_test" {
  name    = "allow-all"
  network = google_compute_network.docker_network.name

  allow {
    protocol = "tcp"
    ports    = ["1-65535"]
  }

  source_ranges = ["0.0.0.0/0"]
}
