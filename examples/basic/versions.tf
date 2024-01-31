terraform {
  required_providers {
    gitlab = {
      source  = "gitlabhq/gitlab"
      version = ">= 16.0.0"
    }
  }
  required_version = ">= 1.3.0"
}
