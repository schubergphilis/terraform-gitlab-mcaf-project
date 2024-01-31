provider "gitlab" {}

module "test_project" {
  source = "../.."

  name      = "test"
  namespace = "test"

  branch_protection = {
    main = {
      allowed_to_push  = { users = ["user1", "user2"] }
      allowed_to_merge = { groups = ["foo/bar"] }
    }
  }
}
