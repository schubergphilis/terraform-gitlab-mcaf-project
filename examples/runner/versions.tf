terraform {
  required_providers {
    gitlab = {
      source  = "gitlabhq/gitlab"
      version = ">= 16.0.0"
    }
    aws = {
      source  = "hashicorp/aws"
      version = ">= 5.37.0"
    }
  }
  required_version = ">= 1.3.0"
}
