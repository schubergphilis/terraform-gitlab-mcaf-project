# terraform-gitlab-mcaf-project

Terraform module to create and manage a GitLab project.

<!--- BEGIN_TF_DOCS --->
## Requirements

| Name | Version |
|------|---------|
| terraform | >= 0.13 |

## Providers

| Name | Version |
|------|---------|
| gitlab | n/a |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| name | The name of the project | `string` | n/a | yes |
| namespace | The namespace (group or user) of the project | `string` | n/a | yes |
| approvals\_before\_merge | Number of merge request approvals required for merging | `number` | `1` | no |
| branch\_protection | Branch protection settings | <pre>map(object({<br>    push_access_level            = string<br>    merge_access_level           = string<br>    code_owner_approval_required = bool<br>  }))</pre> | `null` | no |
| default\_branch | The default branch for the project | `string` | `"master"` | no |
| description | A description for the GitLab project | `string` | `null` | no |
| initialize\_with\_readme | Create default branch with first commit containing a README.md file | `bool` | `true` | no |
| issues\_enabled | Enable issue tracking for the project | `bool` | `false` | no |
| snippets\_enabled | Enable snippets for the project | `bool` | `false` | no |
| visibility | Set the GitLab project as public, private or internal | `string` | `"private"` | no |
| wiki\_enabled | Enable wiki for the project | `bool` | `false` | no |

## Outputs

No output.

<!--- END_TF_DOCS --->
