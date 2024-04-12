mock_provider "gitlab" {
  mock_data "gitlab_group" {
    defaults = {
      id = "12345"
    }
  }

  mock_data "gitlab_user" {
    defaults = {
      id = "67890"
    }
  }
}

run "setup" {
  module {
    source = "./tests/setup"
  }
}

run "defaults" {
  variables {
    name      = "basic-${run.setup.random_string}"
    namespace = "basic-${run.setup.random_string}"
  }

  module {
    source = "./"
  }

  command = plan

  assert {
    condition     = resource.gitlab_project.default.name == "basic-${run.setup.random_string}"
    error_message = "Invalid project name"
  }

  assert {
    condition     = resource.gitlab_project.default.namespace_id == 12345
    error_message = "Invalid project namespace"
  }

  assert {
    condition     = resource.gitlab_project.default.default_branch == "main"
    error_message = "Invalid default branch"
  }

  assert {
    condition     = resource.gitlab_project.default.description == null
    error_message = "Invalid project description"
  }

  assert {
    condition     = resource.gitlab_project.default.initialize_with_readme == true
    error_message = "Invalid initialize_with_readme value"
  }

  assert {
    condition     = resource.gitlab_project.default.issues_enabled == false
    error_message = "Invalid issues_enabled value"
  }

  assert {
    condition     = resource.gitlab_project.default.snippets_enabled == false
    error_message = "Invalid snippets_enabled value"
  }

  assert {
    condition     = resource.gitlab_project.default.visibility_level == "private"
    error_message = "Invalid visibility_level value"
  }

  assert {
    condition     = resource.gitlab_project.default.only_allow_merge_if_all_discussions_are_resolved == false
    error_message = "Invalid only_allow_merge_if_all_discussions_are_resolved value"
  }

  assert {
    condition     = resource.gitlab_project.default.only_allow_merge_if_pipeline_succeeds == false
    error_message = "Invalid only_allow_merge_if_pipeline_succeeds value"
  }

  assert {
    condition     = resource.gitlab_project.default.remove_source_branch_after_merge == true
    error_message = "Invalid remove_source_branch_after_merge value"
  }

  assert {
    condition     = resource.gitlab_project.default.wiki_enabled == false
    error_message = "Invalid wiki_enabled value"
  }

  assert {
    condition     = resource.gitlab_project.default.push_rules != null
    error_message = "push_rules object should not be null"
  }

  assert {
    condition     = resource.gitlab_project.default.push_rules[0].prevent_secrets == true
    error_message = "Invalid prevent_secrets value"
  }

  assert {
    condition     = resource.gitlab_branch_protection.default["main"].merge_access_level == "developer"
    error_message = "Invalid merge_access_level value"
  }

  assert {
    condition     = resource.gitlab_branch_protection.default["main"].push_access_level == "no one"
    error_message = "Invalid push_access_level value"
  }

  assert {
    condition     = resource.gitlab_branch_protection.default["main"].allow_force_push == false
    error_message = "Allow Force push should be disabled"
  }

  assert {
    condition     = resource.gitlab_branch_protection.default["main"].code_owner_approval_required == false
    error_message = "Code owner approval should not be required"
  }
}

run "complete" {
  variables {
    name      = "basic-${run.setup.random_string}"
    namespace = "basic-${run.setup.random_string}"

    approvals_before_merge                           = 2
    commit_message_regex                             = "Fixed \\d+\\..*"
    default_branch                                   = "main"
    description                                      = "test project"
    initialize_with_readme                           = true
    issues_enabled                                   = true
    prevent_secrets                                  = false
    squash_option                                    = "always"
    remove_source_branch_after_merge                 = false
    only_allow_merge_if_all_discussions_are_resolved = true
    only_allow_merge_if_pipeline_succeeds            = true
    snippets_enabled                                 = true
    visibility                                       = "internal"
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

  module {
    source = "./"
  }

  command = plan

  assert {
    condition     = resource.gitlab_project.default.approvals_before_merge == 2
    error_message = "Invalid approvals_before_merge value"
  }

  assert {
    condition     = resource.gitlab_project.default.description == "test project"
    error_message = "Invalid project description"
  }

  assert {
    condition     = resource.gitlab_project.default.initialize_with_readme == true
    error_message = "Invalid initialize_with_readme value"
  }

  assert {
    condition     = resource.gitlab_project.default.issues_enabled == true
    error_message = "Invalid issues_enabled value"
  }

  assert {
    condition     = resource.gitlab_project.default.snippets_enabled == true
    error_message = "Invalid snippets_enabled value"
  }

  assert {
    condition     = resource.gitlab_project.default.only_allow_merge_if_all_discussions_are_resolved == true
    error_message = "Invalid only_allow_merge_if_all_discussions_are_resolved value"
  }

  assert {
    condition     = resource.gitlab_project.default.only_allow_merge_if_pipeline_succeeds == true
    error_message = "Invalid only_allow_merge_if_pipeline_succeeds value"
  }

  assert {
    condition     = resource.gitlab_project.default.remove_source_branch_after_merge == false
    error_message = "Invalid remove_source_branch_after_merge value"
  }

  assert {
    condition     = resource.gitlab_project.default.visibility_level == "internal"
    error_message = "Invalid visibility_level value"
  }

  assert {
    condition     = resource.gitlab_project.default.push_rules[0].prevent_secrets == false
    error_message = "Invalid prevent_secrets value"
  }

  assert {
    condition     = resource.gitlab_branch_protection.default["main"].allow_force_push == false
    error_message = "Allow Force push should be disabled on main branch"
  }

  assert {
    condition     = resource.gitlab_branch_protection.default["main"].code_owner_approval_required == true
    error_message = "Code owner approval should not be required on main branch"
  }

  assert {
    condition     = resource.gitlab_branch_protection.default["main"].merge_access_level == "maintainer"
    error_message = "Invalid merge_access_level value on main branch"
  }

  assert {
    condition     = resource.gitlab_branch_protection.default["main"].push_access_level == "no one"
    error_message = "Invalid push_access_level value on main branch"
  }

  assert {
    condition     = resource.gitlab_branch_protection.default["main"].allowed_to_merge != null
    error_message = "allowed_to_merge object should not be null on main branch"
  }

  assert {
    condition     = resource.gitlab_branch_protection.default["main"].allowed_to_push != null
    error_message = "allowed_to_push object should not be null on main branch"
  }

  assert {
    condition     = resource.gitlab_branch_protection.default["develop"].allow_force_push == true
    error_message = "Allow Force push should be enabled on develop branch"
  }

  assert {
    condition     = resource.gitlab_branch_protection.default["develop"].code_owner_approval_required == false
    error_message = "Code owner approval should not be required on develop branch"
  }

  assert {
    condition     = resource.gitlab_branch_protection.default["develop"].merge_access_level == "developer"
    error_message = "Invalid merge_access_level value on develop branch"
  }

  assert {
    condition     = resource.gitlab_branch_protection.default["develop"].push_access_level == "developer"
    error_message = "Invalid push_access_level value on develop branch"
  }

  assert {
    condition     = resource.gitlab_branch_protection.default["develop"].allowed_to_merge != null
    error_message = "allowed_to_merge object should not be null on develop branch"
  }

  assert {
    condition     = resource.gitlab_branch_protection.default["develop"].allowed_to_push != null
    error_message = "allowed_to_push object should not be null on develop branch"
  }
}


run "failures" {
  command = plan

  module {
    source = "./"
  }

  variables {
    name      = "basic-${run.setup.random_string}"
    namespace = "basic-${run.setup.random_string}"

    visibility    = "visible"
    squash_option = "maybe"
  }

  expect_failures = [
    var.visibility,
    var.squash_option
  ]
}
