locals {
  branch_protection = merge({
    (var.default_branch) = {
      push_access_level            = "no one"
      merge_access_level           = "developer"
      code_owner_approval_required = false
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
  name                   = var.name
  approvals_before_merge = var.use_group_settings ? null : var.approvals_before_merge
  default_branch         = var.default_branch
  description            = var.description
  initialize_with_readme = var.initialize_with_readme
  issues_enabled         = var.issues_enabled
  namespace_id           = data.gitlab_group.default.id
  snippets_enabled       = var.snippets_enabled
  visibility_level       = var.visibility
  wiki_enabled           = var.wiki_enabled

  push_rules {
    prevent_secrets = var.prevent_secrets
  }
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

  allow_force_push             = each.value.allow_force_push
  branch                       = each.key
  code_owner_approval_required = each.value.code_owner_approval_required
  merge_access_level           = each.value.merge_access_level
  project                      = gitlab_project.default.id
  push_access_level            = each.value.push_access_level
  unprotect_access_level       = each.value.unprotect_access_level

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
