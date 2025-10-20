terraform {
  required_providers {
    gitlab = {
      source  = "gitlabhq/gitlab"
      version = ">= 17.10.0"
    }
  }
  required_version = ">= 1.3.0"
}
