provider "gitlab" {}

module "test_project" {
  source = "../.."

  name      = "test"
  namespace = "test"

  branch_protection = {
    main = {
      users_allowed_to_push   = ["user1", "user2"]
      groups_allowed_to_merge = ["foo/bar"]
    }
  }
}
