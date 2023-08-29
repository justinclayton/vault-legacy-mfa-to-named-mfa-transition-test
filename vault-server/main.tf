# Terraform configuration for running Vault Enterprise in a Docker container
terraform {
  required_providers {
    docker = {
      source = "kreuzwerker/docker"
      version = "3.0.2"
    }
  }
}

# Configure the Docker provider
provider "docker" {}

# Define the Docker container resource
resource "docker_container" "vault" {
  image = var.docker_image
  name  = "vault_named_mfa"
  rm    = true

  env = [
    "VAULT_LICENSE=${file(var.vault_license)}"
  ]

  ports {
    internal = 8200
    external = 8200
  }
}