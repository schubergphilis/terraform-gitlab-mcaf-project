locals {
  branch_protection = merge({
    (var.default_branch) = {
      push_access_level            = "no one"
      merge_access_level           = "developer"
      code_owner_approval_required = false
    }
  }, var.branch_protection)
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
}

################################################################################
# Branch protection
################################################################################

data "gitlab_user" "allowed_to_merge" {
  for_each = local.branch_protection.allowed_to_merge.users

  username = each.value
}

data "gitlab_user" "allowed_to_push" {
  for_each = local.branch_protection.allowed_to_push.users

  username = each.value
}

data "gitlab_user" "allowed_to_unprotect" {
  for_each = local.branch_protection.allowed_to_unprotect.users

  username = each.value
}

data "gitlab_group" "allowed_to_merge" {
  for_each = local.branch_protection.allowed_to_merge.groups

  full_path = each.value
}

data "gitlab_group" "allowed_to_push" {
  for_each = local.branch_protection.allowed_to_push.groups

  full_path = each.value
}

data "gitlab_group" "allowed_to_unprotect" {
  for_each = local.branch_protection.allowed_to_unprotect.groups

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
    for_each = each.value.allowed_to_merge.users

    content {
      user_id = data.gitlab_user.allowed_to_merge[allowed_to_merge.value].id
    }
  }

  dynamic "allowed_to_merge" {
    for_each = each.value.allowed_to_merge.groups

    content {
      group_id = data.gitlab_group.allowed_to_merge[allowed_to_merge.value].id
    }
  }

  dynamic "allowed_to_push" {
    for_each = each.value.allowed_to_push.users

    content {
      user_id = data.gitlab_user.allowed_to_push[allowed_to_push.value].id
    }
  }

  dynamic "allowed_to_push" {
    for_each = each.value.allowed_to_push.groups

    content {
      group_id = data.gitlab_group.allowed_to_push[allowed_to_push.value].id
    }
  }

  dynamic "allowed_to_unprotect" {
    for_each = each.value.allowed_to_unprotect.users

    content {
      user_id = data.gitlab_user.allowed_to_unprotect[allowed_to_unprotect.value].id
    }
  }

  dynamic "allowed_to_unprotect" {
    for_each = each.value.allowed_to_unprotect.groups

    content {
      group_id = data.gitlab_group.allowed_to_unprotect[allowed_to_unprotect.value].id
    }
  }
}
