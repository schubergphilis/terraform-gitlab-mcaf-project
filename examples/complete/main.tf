provider "gitlab" {}

module "test_project" {
  source = "../.."

  name      = "test"
  namespace = "test"

  approvals_before_merge                           = 2
  commit_message_regex                             = "Fixed \\d+\\..*"
  default_branch                                   = "main"
  description                                      = "test project"
  initialize_with_readme                           = true
  issues_enabled                                   = true
  prevent_secrets                                  = false
  snippets_enabled                                 = true
  squash_option                                    = "always"
  remove_source_branch_after_merge                 = true
  visibility                                       = "internal"
  only_allow_merge_if_all_discussions_are_resolved = true
  only_allow_merge_if_pipeline_succeeds            = true
  wiki_enabled                                     = true

  branch_protection = {
    main = {
      allow_force_push             = false
      code_owner_approval_required = true
      merge_access_level           = "maintainer"
      push_access_level            = "no one"
      users_allowed_to_push        = ["user1"]
      groups_allowed_to_merge      = ["foo/group1"]
    }
    develop = {
      allow_force_push             = true
      code_owner_approval_required = false
      merge_access_level           = "developer"
      push_access_level            = "developer"
      users_allowed_to_push        = ["user2"]
      groups_allowed_to_merge      = ["foo/group2"]
    }
  }
}
