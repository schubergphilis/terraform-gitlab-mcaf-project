# terraform-gitlab-mcaf-project

Terraform module to create and manage a GitLab project.

IMPORTANT: We do not pin modules to versions in our examples. We highly recommend that in your code you pin the version to the exact version you are using so that your infrastructure remains stable.

<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.3.0 |
| <a name="requirement_gitlab"></a> [gitlab](#requirement\_gitlab) | >= 16.0.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_gitlab"></a> [gitlab](#provider\_gitlab) | >= 16.0.0 |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [gitlab_branch_protection.default](https://registry.terraform.io/providers/gitlabhq/gitlab/latest/docs/resources/branch_protection) | resource |
| [gitlab_project.default](https://registry.terraform.io/providers/gitlabhq/gitlab/latest/docs/resources/project) | resource |
| [gitlab_group.default](https://registry.terraform.io/providers/gitlabhq/gitlab/latest/docs/data-sources/group) | data source |
| [gitlab_group.groups](https://registry.terraform.io/providers/gitlabhq/gitlab/latest/docs/data-sources/group) | data source |
| [gitlab_user.users](https://registry.terraform.io/providers/gitlabhq/gitlab/latest/docs/data-sources/user) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_name"></a> [name](#input\_name) | The name of the project | `string` | n/a | yes |
| <a name="input_namespace"></a> [namespace](#input\_namespace) | The namespace (group or user) of the project | `string` | n/a | yes |
| <a name="input_approvals_before_merge"></a> [approvals\_before\_merge](#input\_approvals\_before\_merge) | Number of merge request approvals required for merging | `number` | `1` | no |
| <a name="input_branch_protection"></a> [branch\_protection](#input\_branch\_protection) | Branch protection settings | <pre>map(object({<br>    allow_force_push             = optional(bool, false)<br>    code_owner_approval_required = optional(bool, false)<br>    merge_access_level           = optional(string, "developer")<br>    push_access_level            = optional(string, "no one")<br>    unprotect_access_level       = optional(string)<br><br>    groups_allowed_to_merge     = optional(list(string), [])<br>    groups_allowed_to_push      = optional(list(string), [])<br>    groups_allowed_to_unprotect = optional(list(string), [])<br><br>    users_allowed_to_merge     = optional(list(string), [])<br>    users_allowed_to_push      = optional(list(string), [])<br>    users_allowed_to_unprotect = optional(list(string), [])<br>  }))</pre> | `{}` | no |
| <a name="input_commit_message_regex"></a> [commit\_message\_regex](#input\_commit\_message\_regex) | A regex pattern that a commit message must match in order to be accepted. | `string` | `null` | no |
| <a name="input_default_branch"></a> [default\_branch](#input\_default\_branch) | The default branch for the project | `string` | `"main"` | no |
| <a name="input_description"></a> [description](#input\_description) | A description for the GitLab project | `string` | `null` | no |
| <a name="input_initialize_with_readme"></a> [initialize\_with\_readme](#input\_initialize\_with\_readme) | Create default branch with first commit containing a README.md file | `bool` | `true` | no |
| <a name="input_issues_enabled"></a> [issues\_enabled](#input\_issues\_enabled) | Enable issue tracking for the project | `bool` | `false` | no |
| <a name="input_only_allow_merge_if_all_discussions_are_resolved"></a> [only\_allow\_merge\_if\_all\_discussions\_are\_resolved](#input\_only\_allow\_merge\_if\_all\_discussions\_are\_resolved) | Set to true if you want allow merges only if all discussions are resolved. | `bool` | `false` | no |
| <a name="input_only_allow_merge_if_pipeline_succeeds"></a> [only\_allow\_merge\_if\_pipeline\_succeeds](#input\_only\_allow\_merge\_if\_pipeline\_succeeds) | Set to true if you want allow merges only if a pipeline succeeds. | `bool` | `false` | no |
| <a name="input_prevent_secrets"></a> [prevent\_secrets](#input\_prevent\_secrets) | GitLab rejects any files that are likely to contain secrets. | `bool` | `true` | no |
| <a name="input_reject_unsigned_commits"></a> [reject\_unsigned\_commits](#input\_reject\_unsigned\_commits) | GitLab rejects any unsigned commits. | `bool` | `true` | no |
| <a name="input_remove_source_branch_after_merge"></a> [remove\_source\_branch\_after\_merge](#input\_remove\_source\_branch\_after\_merge) | Enable "Delete source branch" option by default for all new merge requests. | `bool` | `true` | no |
| <a name="input_snippets_enabled"></a> [snippets\_enabled](#input\_snippets\_enabled) | Enable snippets for the project | `bool` | `false` | no |
| <a name="input_squash_option"></a> [squash\_option](#input\_squash\_option) | Squash commits when merge request | `string` | `"default_off"` | no |
| <a name="input_use_group_settings"></a> [use\_group\_settings](#input\_use\_group\_settings) | Ignore settings that can also be set on a group level to prevent conflicts | `bool` | `false` | no |
| <a name="input_visibility"></a> [visibility](#input\_visibility) | Set the GitLab project as public, private or internal | `string` | `"private"` | no |
| <a name="input_wiki_enabled"></a> [wiki\_enabled](#input\_wiki\_enabled) | Enable wiki for the project | `bool` | `false` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_id"></a> [id](#output\_id) | GitLab project id |
| <a name="output_path"></a> [path](#output\_path) | GitLab project path |
| <a name="output_path_with_namespace"></a> [path\_with\_namespace](#output\_path\_with\_namespace) | GitLab project path with namespace |
<!-- END_TF_DOCS -->
