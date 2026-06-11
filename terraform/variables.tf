variable "yc_token" {
  description = "Yandex Cloud OAuth token"
  sensitive   = true
}

variable "cloud_id" {
  description = "Yandex Cloud ID"
}

variable "folder_id" {
  description = "Yandex Folder ID"
}

variable "zone" {
  description = "Yandex Cloud zone"
}

variable "ssh_public_key_path" {
  description = "Path to SSH public key"
}

variable "docker_image" {
  description = "Docker image to deploy"
  default     = "solseracc/my-fastapi:latest"
}