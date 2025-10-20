# Upgrading Notes

This document captures required refactoring on your part when upgrading to a module version that contains breaking changes.

## Upgrading to v1.0.0

### Key Changes 

- This module now requires a minimum GitLab provider version of 17.10.0.

### Variables

The following variables have been removed in favor of the dedicated resource `gitlab_project_approval_rule`, which can be modified by the variable `var.project_approval_rule`:

- `approvals_before_merge`
- `use_group_settings`

The following variables have been changed in favor of newer, recommended attributes:

- `issues_enabled` is now `issues_access_level` and accepts either of the valid inputs: `disabled`, `private`, or `enabled`.
- `snippets_enabled` is now `snippets_access_level` and accepts either of the valid inputs: `disabled`, `private`, or `enabled`.
- `wiki_enabled` is now `wiki_access_level` and accepts either of the valid inputs: `disabled`, `private`, or `enabled`.

### How to Upgrade

- Remove all `approvals_before_merge` and `use_group_settings` inputs when using this module. Use the `project_approval_rule` variable instead when managing approval rules.
- Rename all instances of `issues_enabled` to `issues_access_level`
- Rename all instances of `snippets_enabled` to `snippets_access_level`
- Rename all instances of `wiki_enabled` to `wiki_access_level`
- If the value is `true` for any of the variables above, set the value to either `enabled` or `private` (see the [GitLab Projects API Reference](https://docs.gitlab.com/api/projects/#manage-projects) for more information about these values). If these variables are not defined when using the module, then no further action is needed as they all default to `disabled`.