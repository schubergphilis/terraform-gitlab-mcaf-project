data "gitlab_group" "default" {
  full_path = var.namespace
}

resource "gitlab_project" "default" {
  name                   = var.name
  approvals_before_merge = var.approvals_before_merge
  default_branch         = var.default_branch
  description            = var.description
  issues_enabled         = var.issues_enabled
  namespace_id           = data.gitlab_group.default.id
  snippets_enabled       = var.snippets_enabled
  visibility_level       = var.visibility
  wiki_enabled           = var.wiki_enabled
}
