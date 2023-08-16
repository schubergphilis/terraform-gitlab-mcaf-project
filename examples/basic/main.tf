provider "gitlab" {}

module "test_project" {
  source = "../.."

  name      = "test"
  namespace = "test"
}
