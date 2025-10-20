# terraform-gitlab-mcaf-project

Terraform module to create and manage a GitLab project.

IMPORTANT: We do not pin modules to versions in our examples. We highly recommend that in your code you pin the version to the exact version you are using so that your infrastructure remains stable.

<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.3.0 |
| <a name="requirement_gitlab"></a> [gitlab](#requirement\_gitlab) | >= 17.10.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_gitlab"></a> [gitlab](#provider\_gitlab) | >= 17.10.0 |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [gitlab_branch_protection.default](https://registry.terraform.io/providers/gitlabhq/gitlab/latest/docs/resources/branch_protection) | resource |
| [gitlab_pipeline_schedule.default](https://registry.terraform.io/providers/gitlabhq/gitlab/latest/docs/resources/pipeline_schedule) | resource |
| [gitlab_project.default](https://registry.terraform.io/providers/gitlabhq/gitlab/latest/docs/resources/project) | resource |
| [gitlab_project_approval_rule.default](https://registry.terraform.io/providers/gitlabhq/gitlab/latest/docs/resources/project_approval_rule) | resource |
| [gitlab_project_level_mr_approvals.default](https://registry.terraform.io/providers/gitlabhq/gitlab/latest/docs/resources/project_level_mr_approvals) | resource |
| [gitlab_project_variable.default](https://registry.terraform.io/providers/gitlabhq/gitlab/latest/docs/resources/project_variable) | resource |
| [gitlab_group.default](https://registry.terraform.io/providers/gitlabhq/gitlab/latest/docs/data-sources/group) | data source |
| [gitlab_group.groups](https://registry.terraform.io/providers/gitlabhq/gitlab/latest/docs/data-sources/group) | data source |
| [gitlab_group.project_approval_rule_groups](https://registry.terraform.io/providers/gitlabhq/gitlab/latest/docs/data-sources/group) | data source |
| [gitlab_user.project_approval_rule_users](https://registry.terraform.io/providers/gitlabhq/gitlab/latest/docs/data-sources/user) | data source |
| [gitlab_user.users](https://registry.terraform.io/providers/gitlabhq/gitlab/latest/docs/data-sources/user) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_name"></a> [name](#input\_name) | The name of the project | `string` | n/a | yes |
| <a name="input_namespace"></a> [namespace](#input\_namespace) | The namespace (group or user) of the project | `string` | n/a | yes |
| <a name="input_branch_protection"></a> [branch\_protection](#input\_branch\_protection) | Branch protection settings | <pre>map(object({<br/>    allow_force_push             = optional(bool, false)<br/>    code_owner_approval_required = optional(bool, false)<br/>    merge_access_level           = optional(string, "developer")<br/>    push_access_level            = optional(string, "no one")<br/>    unprotect_access_level       = optional(string)<br/><br/>    groups_allowed_to_merge     = optional(list(string), [])<br/>    groups_allowed_to_push      = optional(list(string), [])<br/>    groups_allowed_to_unprotect = optional(list(string), [])<br/><br/>    users_allowed_to_merge     = optional(list(string), [])<br/>    users_allowed_to_push      = optional(list(string), [])<br/>    users_allowed_to_unprotect = optional(list(string), [])<br/>  }))</pre> | `{}` | no |
| <a name="input_ci_config_path"></a> [ci\_config\_path](#input\_ci\_config\_path) | Custom Path to CI config file. | `string` | `".gitlab-ci.yml"` | no |
| <a name="input_ci_default_git_depth"></a> [ci\_default\_git\_depth](#input\_ci\_default\_git\_depth) | Default number of revisions for shallow cloning. | `number` | `3` | no |
| <a name="input_cicd_variables"></a> [cicd\_variables](#input\_cicd\_variables) | CICD variables accessable during pipeline runs. | <pre>map(object({<br/>    value         = string<br/>    protected     = bool<br/>    description   = optional(string, null)<br/>    hidden        = optional(bool, false)<br/>    masked        = optional(bool, false)<br/>    raw           = optional(bool, false)<br/>    variable_type = optional(string, "env_var")<br/>  }))</pre> | `{}` | no |
| <a name="input_commit_message_regex"></a> [commit\_message\_regex](#input\_commit\_message\_regex) | A regex pattern that a commit message must match in order to be accepted. | `string` | `null` | no |
| <a name="input_default_branch"></a> [default\_branch](#input\_default\_branch) | The default branch for the project | `string` | `"main"` | no |
| <a name="input_description"></a> [description](#input\_description) | A description for the GitLab project | `string` | `null` | no |
| <a name="input_initialize_with_readme"></a> [initialize\_with\_readme](#input\_initialize\_with\_readme) | Create default branch with first commit containing a README.md file | `bool` | `true` | no |
| <a name="input_issues_access_level"></a> [issues\_access\_level](#input\_issues\_access\_level) | Set the issues access level. Valid values are "disabled", "private", "enabled". | `string` | `"disabled"` | no |
| <a name="input_merge_request_approval_rule"></a> [merge\_request\_approval\_rule](#input\_merge\_request\_approval\_rule) | Allows to manage the lifecycle of a Merge Request-level approval rule. | <pre>object({<br/>    disable_overriding_approvers_per_merge_request = optional(bool, false)<br/>    merge_requests_author_approval                 = optional(bool, false)<br/>    merge_requests_disable_committers_approval     = optional(bool, false)<br/>    reset_approvals_on_push                        = optional(bool, true)<br/>  })</pre> | `{}` | no |
| <a name="input_only_allow_merge_if_all_discussions_are_resolved"></a> [only\_allow\_merge\_if\_all\_discussions\_are\_resolved](#input\_only\_allow\_merge\_if\_all\_discussions\_are\_resolved) | Set to true if you want allow merges only if all discussions are resolved. | `bool` | `false` | no |
| <a name="input_only_allow_merge_if_pipeline_succeeds"></a> [only\_allow\_merge\_if\_pipeline\_succeeds](#input\_only\_allow\_merge\_if\_pipeline\_succeeds) | Set to true if you want allow merges only if a pipeline succeeds. | `bool` | `false` | no |
| <a name="input_pipeline_schedule"></a> [pipeline\_schedule](#input\_pipeline\_schedule) | Pipeline scheduler parameter. | <pre>object({<br/>    active         = optional(bool, true)<br/>    cron           = string<br/>    cron_timezone  = optional(string, "UTC")<br/>    description    = string<br/>    ref            = optional(string, "refs/heads/main")<br/>    take_ownership = optional(bool, false)<br/>  })</pre> | `null` | no |
| <a name="input_prevent_secrets"></a> [prevent\_secrets](#input\_prevent\_secrets) | GitLab rejects any files that are likely to contain secrets. | `bool` | `true` | no |
| <a name="input_project_approval_rule"></a> [project\_approval\_rule](#input\_project\_approval\_rule) | Allows to manage the lifecycle of a project-level approval rule. | <pre>object({<br/>    name                              = optional(string, "project approval rule")<br/>    applies_to_all_protected_branches = optional(bool, true)<br/>    approvals_required                = optional(number, 1)<br/>    groups                            = optional(list(string), [])<br/>    protected_branches                = optional(list(string), null)<br/>    users                             = optional(list(string), [])<br/>  })</pre> | `{}` | no |
| <a name="input_reject_unsigned_commits"></a> [reject\_unsigned\_commits](#input\_reject\_unsigned\_commits) | GitLab rejects any unsigned commits. | `bool` | `true` | no |
| <a name="input_remove_source_branch_after_merge"></a> [remove\_source\_branch\_after\_merge](#input\_remove\_source\_branch\_after\_merge) | Enable "Delete source branch" option by default for all new merge requests. | `bool` | `true` | no |
| <a name="input_snippets_access_level"></a> [snippets\_access\_level](#input\_snippets\_access\_level) | Set the snippets access level. Valid values are "disabled", "private", "enabled". | `string` | `"disabled"` | no |
| <a name="input_squash_option"></a> [squash\_option](#input\_squash\_option) | Squash commits when merge request | `string` | `"default_off"` | no |
| <a name="input_visibility"></a> [visibility](#input\_visibility) | Set the GitLab project as public, private or internal | `string` | `"private"` | no |
| <a name="input_wiki_access_level"></a> [wiki\_access\_level](#input\_wiki\_access\_level) | Set the wiki access level. Valid values are "disabled", "private", "enabled". | `string` | `"disabled"` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_http_url_to_repo"></a> [http\_url\_to\_repo](#output\_http\_url\_to\_repo) | HTTP URL to the repository |
| <a name="output_id"></a> [id](#output\_id) | Project ID |
| <a name="output_path"></a> [path](#output\_path) | Project path |
| <a name="output_path_with_namespace"></a> [path\_with\_namespace](#output\_path\_with\_namespace) | Project path with namespace |
| <a name="output_ssh_url_to_repo"></a> [ssh\_url\_to\_repo](#output\_ssh\_url\_to\_repo) | SSH URL to the repository |
| <a name="output_web_url"></a> [web\_url](#output\_web\_url) | Project web URL |
<!-- END_TF_DOCS -->
