locals {
  branch_protection = merge({
    (var.default_branch) = {
      allow_force_push             = false
      code_owner_approval_required = false
      groups_allowed_to_merge      = []
      groups_allowed_to_push       = []
      groups_allowed_to_unprotect  = []
      merge_access_level           = "developer"
      push_access_level            = "no one"
      users_allowed_to_merge       = []
      users_allowed_to_push        = []
      users_allowed_to_unprotect   = []
    }
  }, var.branch_protection)

  // List of users to look up
  users = toset(flatten([for branch, settings in local.branch_protection :
    distinct(concat(settings.users_allowed_to_merge, settings.users_allowed_to_push, settings.users_allowed_to_unprotect))
  ]))

  // List of groups to look up
  groups = toset(flatten([for branch, settings in local.branch_protection :
    distinct(concat(settings.groups_allowed_to_merge, settings.groups_allowed_to_push, settings.groups_allowed_to_unprotect))
  ]))
}

################################################################################
# Repository
################################################################################

data "gitlab_group" "default" {
  full_path = var.namespace
}

resource "gitlab_project" "default" {
  name                                             = var.name
  approvals_before_merge                           = var.use_group_settings ? null : var.approvals_before_merge
  ci_config_path                                   = var.ci_config_path
  ci_default_git_depth                             = var.ci_default_git_depth
  default_branch                                   = var.default_branch
  description                                      = var.description
  initialize_with_readme                           = var.initialize_with_readme
  issues_enabled                                   = var.issues_enabled
  namespace_id                                     = data.gitlab_group.default.id
  only_allow_merge_if_all_discussions_are_resolved = var.only_allow_merge_if_all_discussions_are_resolved
  only_allow_merge_if_pipeline_succeeds            = var.only_allow_merge_if_pipeline_succeeds
  remove_source_branch_after_merge                 = var.remove_source_branch_after_merge
  snippets_enabled                                 = var.snippets_enabled
  squash_option                                    = var.squash_option
  visibility_level                                 = var.visibility
  wiki_enabled                                     = var.wiki_enabled

  push_rules {
    commit_message_regex    = var.commit_message_regex
    prevent_secrets         = var.prevent_secrets
    reject_unsigned_commits = var.reject_unsigned_commits
  }
}

resource "gitlab_project_variable" "default" {
  for_each = var.cicd_variables

  project       = gitlab_project.default.id
  key           = each.key
  value         = each.value.value
  protected     = each.value.protected
  masked        = each.value.masked
  raw           = each.value.raw
  variable_type = each.value.variable_type
  description   = each.value.variable_type
}

resource "gitlab_project_level_mr_approvals" "default" {
  project                                        = gitlab_project.default.id
  reset_approvals_on_push                        = var.merge_request_approval_rule.reset_approvals_on_push
  disable_overriding_approvers_per_merge_request = var.merge_request_approval_rule.disable_overriding_approvers_per_merge_request
  merge_requests_author_approval                 = var.merge_request_approval_rule.merge_requests_author_approval
  merge_requests_disable_committers_approval     = var.merge_request_approval_rule.merge_requests_disable_committers_approval
}

data "gitlab_user" "project_approval_rule_users" {
  for_each = try(toset(var.project_approval_rule.users), {})

  username = each.value
}

data "gitlab_group" "project_approval_rule_groups" {
  for_each = try(toset(var.project_approval_rule.groups), {})

  full_path = each.value
}

resource "gitlab_project_approval_rule" "default" {
  project                           = gitlab_project.default.id
  name                              = var.project_approval_rule.name
  approvals_required                = var.project_approval_rule.approvals_required
  applies_to_all_protected_branches = var.project_approval_rule.applies_to_all_protected_branches
  protected_branch_ids              = try([for branch in var.project_approval_rule.protected_branches : gitlab_branch_protection.default[branch].id], null)
  user_ids                          = try(data.gitlab_user.project_approval_rule_users[*].id, null)
  group_ids                         = try(data.gitlab_group.project_approval_rule_groups[*].id, null)
}

################################################################################
# Branch protection
################################################################################

data "gitlab_user" "users" {
  for_each = local.users

  username = each.value
}

data "gitlab_group" "groups" {
  for_each = local.groups

  full_path = each.value
}

resource "gitlab_branch_protection" "default" {
  for_each = local.branch_protection

  #checkov:skip=CKV_GLB_2: False positive, default is true
  allow_force_push             = try(each.value.allow_force_push, false)
  branch                       = each.key
  code_owner_approval_required = each.value.code_owner_approval_required
  merge_access_level           = each.value.merge_access_level
  project                      = gitlab_project.default.id
  push_access_level            = each.value.push_access_level
  unprotect_access_level       = try(each.value.unprotect_access_level, null)

  dynamic "allowed_to_merge" {
    for_each = each.value.users_allowed_to_merge

    content {
      user_id = data.gitlab_user.users[allowed_to_merge.value].id
    }
  }

  dynamic "allowed_to_merge" {
    for_each = each.value.groups_allowed_to_merge

    content {
      group_id = data.gitlab_group.groups[allowed_to_merge.value].id
    }
  }

  dynamic "allowed_to_push" {
    for_each = each.value.users_allowed_to_push

    content {
      user_id = data.gitlab_user.users[allowed_to_push.value].id
    }
  }

  dynamic "allowed_to_push" {
    for_each = each.value.groups_allowed_to_push

    content {
      group_id = data.gitlab_group.groups[allowed_to_push.value].id
    }
  }

  dynamic "allowed_to_unprotect" {
    for_each = each.value.users_allowed_to_unprotect

    content {
      user_id = data.gitlab_user.users[allowed_to_unprotect.value].id
    }
  }

  dynamic "allowed_to_unprotect" {
    for_each = each.value.groups_allowed_to_unprotect

    content {
      group_id = data.gitlab_group.groups[allowed_to_unprotect.value].id
    }
  }
}

################################################################################
# Pipeline schedule
################################################################################

resource "gitlab_pipeline_schedule" "default" {
  count  = var.pipeline_schedule.cron != null ? 1 : 0
  active = var.pipeline_schedule.active

  project        = gitlab_project.default.id
  description    = var.pipeline_schedule.description
  ref            = var.pipeline_schedule.ref
  cron           = var.pipeline_schedule.cron
  cron_timezone  = var.pipeline_schedule.cron_timezone
  take_ownership = var.pipeline_schedule.take_ownership

  lifecycle {
    precondition {
      condition     = can(regex("^([0-5]?[0-9]|\\*) ([0-9]|1[0-9]|2[0-3]|\\*) ([1-9]|[12][0-9]|3[01]|\\*) ([1-9]|1[0-2]|\\*) ([0-6]|\\*)$", var.pipeline_schedule.cron))
      error_message = "The cron expression is not valid. It should be in the format '0 1 * * *'."
    }
  }
}
