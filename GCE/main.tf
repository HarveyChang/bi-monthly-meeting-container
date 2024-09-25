data "google_client_config" "default" {}


# 建立 GCE Instance
resource "google_compute_instance" "terraform_vm" {
  name         = "terraform-vm"
  machine_type = var.machine_type
  zone         = var.zone

  # 使用 Ubuntu 作為映像
  boot_disk {
    initialize_params {
      image = "debian-cloud/debian-11"
    }
  }

  network_interface {
    network    = google_compute_network.terraform_network.name
    # subnetwork = google_compute_subnetwork.subnet.name

    # 分配外部 IP
    access_config {
      // 這將分配一個靜態外部 IP
    }
  }

  # tags = ["http-server", "https-server","ssh-server"]

  metadata_startup_script = <<-EOF
    #! /bin/bash
    sudo apt update && sudo apt install git -y
    
    sudo apt-get update && sudo apt-get install -y apt-transport-https ca-certificates curl gnupg2 software-properties-common
    curl -fsSL https://download.docker.com/linux/debian/gpg | sudo apt-key add -
    sudo add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/debian $(lsb_release -cs) stable"
    sudo apt-get update && sudo apt-get install -y docker-ce docker-ce-cli containerd.io
    curl -L "https://github.com/docker/compose/releases/download/v2.29.0/docker-compose-$(uname -s | tr A-Z a-z)-$(uname -m)" -o /usr/local/bin/docker-compose
    sudo chmod +x /usr/local/bin/docker-compose
    sudo usermod -aG docker $USER

    curl -LO "https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl"
    chmod +x kubectl
    sudo mv kubectl /usr/local/bin/

    # 安裝 Minikube
    curl -LO https://storage.googleapis.com/minikube/releases/latest/minikube-linux-amd64
    sudo install minikube-linux-amd64 /usr/local/bin/minikube

    sudo usermod -aG docker $USER && newgrp docker
    minikube start --driver=docker

    # Install Terraform
    curl -fsSL https://apt.releases.hashicorp.com/gpg | sudo apt-key add -
    apt-add-repository "deb [arch=amd64] https://apt.releases.hashicorp.com $(lsb_release -cs) main"
    apt update && apt install --yes terraform

  EOF

#   # 啟用 SSH 訪問
#   metadata = {
#     ssh-keys = "YOUR_SSH_KEY"
#   }

  # provisioner "remote-exec" {
  #   inline = [
  #     "while ! minikube status | grep -q 'host: Running'; do echo 'Waiting for Minikube to start...'; sleep 10; done",
  #     "echo 'Minikube is running!'"
  #   ]

  #   connection {
  #     type        = "ssh"
  #     user        = "your-username"
  #     private_key = file("path/to/your/private/key")
  #     host        = google_compute_instance.default.network_interface[0].access_config[0].nat_ip
  #   }
  # }


}
