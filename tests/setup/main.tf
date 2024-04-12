terraform {
  required_providers {
    random = {
      source  = "hashicorp/random"
      version = "3.5.1"
    }
  }
  required_version = ">= 1.3.0"
}

resource "random_string" "default" {
  length  = 4
  special = false
  upper   = false
}

output "random_string" {
  value = random_string.default.id
}
