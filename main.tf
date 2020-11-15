locals {
  branch_protection = merge({
    (var.default_branch) = {
      push_access_level            = "no one"
      merge_access_level           = "developer"
      code_owner_approval_required = false
    }
  }, null)
}

data "gitlab_group" "default" {
  full_path = var.namespace
}

resource "gitlab_project" "default" {
  name                   = var.name
  approvals_before_merge = var.approvals_before_merge
  default_branch         = var.default_branch
  description            = var.description
  initialize_with_readme = var.initialize_with_readme
  issues_enabled         = var.issues_enabled
  namespace_id           = data.gitlab_group.default.id
  snippets_enabled       = var.snippets_enabled
  visibility_level       = var.visibility
  wiki_enabled           = var.wiki_enabled
}

resource "gitlab_branch_protection" "default" {
  for_each           = local.branch_protection
  project            = gitlab_project.default.id
  branch             = each.key
  push_access_level  = each.value.push_access_level
  merge_access_level = each.value.merge_access_level
}
