provider "gitlab" {}
provider "aws" {}

module "test_project_with_runner" {
  source = "../.."

  name      = "test-runner"
  namespace = "test-runner"

  branch_protection = {
    main = {
      users_allowed_to_push = ["admin_user"]
    }
  }

  runner = {
    description       = "Test runner"
    tag_list          = ["test"]
    runner_type       = "project_type"
    ssm_create_secret = true
    ssm_tags = {
      gitlab = true
      test   = true
    }
  }
}
