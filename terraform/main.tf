terraform {
  required_version = ">= 1.0"
  required_providers {
    yandex = {
      source  = "yandex-cloud/yandex"
      version = "~> 0.100"
    }
  }
}

provider "yandex" {
  token     = var.yc_token
  cloud_id  = var.cloud_id
  folder_id = var.folder_id
  zone      = var.zone
}

resource "yandex_vpc_network" "app_network" {
  name = "fastapi-network"
}

resource "yandex_vpc_subnet" "app_subnet" {
  name           = "fastapi-subnet"
  zone           = var.zone
  network_id     = yandex_vpc_network.app_network.id
  v4_cidr_blocks = ["10.10.0.0/24"]
}

resource "yandex_vpc_security_group" "app_sg" {
  name        = "fastapi-security-group"
  network_id  = yandex_vpc_network.app_network.id

  ingress {
    protocol       = "TCP"
    description    = "SSH"
    v4_cidr_blocks = ["0.0.0.0/0"]
    port           = 22
  }

  ingress {
    protocol       = "TCP"
    description    = "HTTP"
    v4_cidr_blocks = ["0.0.0.0/0"]
    port           = 80
  }

  ingress {
    protocol       = "TCP"
    description    = "FastAPI"
    v4_cidr_blocks = ["0.0.0.0/0"]
    port           = 8000
  }

  egress {
    protocol       = "ANY"
    description    = "All outbound"
    v4_cidr_blocks = ["0.0.0.0/0"]
    from_port      = 0
    to_port        = 65535
  }
}

resource "yandex_compute_instance" "app_vm" {
  name        = "fastapi-vm"
  zone        = var.zone
  platform_id = "standard-v3"

  resources {
    cores  = 2
    memory = 2
  }

  boot_disk {
    initialize_params {
      image_id = "fd80bm0rh4rkepi5v2tb" # Ubuntu 22.04
      size     = 20
    }
  }

  network_interface {
    subnet_id          = yandex_vpc_subnet.app_subnet.id
    security_group_ids = [yandex_vpc_security_group.app_sg.id]
    nat                = true
  }

  metadata = {
    ssh-keys = "ubuntu:${file(var.ssh_public_key_path)}"
  }
}

output "web_public_ip" {
  value = yandex_compute_instance.app_vm.network_interface[0].nat_ip_address
}

output "service_url" {
  value = "http://${yandex_compute_instance.app_vm.network_interface[0].nat_ip_address}/health"
}