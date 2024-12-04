variable "approvals_before_merge" {
  type        = number
  default     = 1
  description = "Number of merge request approvals required for merging"
}

variable "ci_config_path" {
  type        = string
  default     = ".gitlab-ci.yml"
  description = "Custom Path to CI config file."
}

variable "ci_default_git_depth" {
  type        = number
  default     = 1
  description = "Default number of revisions for shallow cloning."
}

variable "branch_protection" {
  type = map(object({
    allow_force_push             = optional(bool, false)
    code_owner_approval_required = optional(bool, false)
    merge_access_level           = optional(string, "developer")
    push_access_level            = optional(string, "no one")
    unprotect_access_level       = optional(string)

    groups_allowed_to_merge     = optional(list(string), [])
    groups_allowed_to_push      = optional(list(string), [])
    groups_allowed_to_unprotect = optional(list(string), [])

    users_allowed_to_merge     = optional(list(string), [])
    users_allowed_to_push      = optional(list(string), [])
    users_allowed_to_unprotect = optional(list(string), [])
  }))
  default     = {}
  description = "Branch protection settings"
}

variable "merge_request_approval_rule" {
  type = object({
    disable_overriding_approvers_per_merge_request = optional(bool, false)
    merge_requests_author_approval                 = optional(bool, false)
    merge_requests_disable_committers_approval     = optional(bool, false)
    reset_approvals_on_push                        = optional(bool, true)
  })
  default     = {}
  description = "Allows to manage the lifecycle of a Merge Request-level approval rule."
}

variable "project_approval_rule" {
  type = object({
    name                              = optional(string, "project approval rule")
    applies_to_all_protected_branches = optional(bool, true)
    approvals_required                = optional(number, 1)
    groups                            = optional(list(string), [])
    protected_branches                = optional(list(string), null)
    users                             = optional(list(string), [])
  })
  default     = {}
  description = "Allows to manage the lifecycle of a project-level approval rule."

  validation {
    condition     = var.project_approval_rule.applies_to_all_protected_branches == false || var.project_approval_rule.protected_branches == null
    error_message = "Only one of either applies_to_all_protected_branches or protected_branches may be set."
  }
}

variable "cicd_variables" {
  type = map(object({
    value         = string
    protected     = bool
    masked        = optional(bool, false)
    raw           = optional(bool, false)
    variable_type = optional(string, "env_var")
  }))
  default     = {}
  description = "CICD variables accessable during pipeline runs."

  validation {
    condition = alltrue([
      for v in var.cicd_variables : v.variable_type == "env_var" || v.variable_type == "file"
    ])
    error_message = "The variable_type must be either 'env_var' or 'file'."
  }
}

variable "commit_message_regex" {
  type        = string
  default     = null
  description = "A regex pattern that a commit message must match in order to be accepted."
}

variable "default_branch" {
  type        = string
  default     = "main"
  description = "The default branch for the project"
}

variable "description" {
  type        = string
  default     = null
  description = "A description for the GitLab project"
}

variable "initialize_with_readme" {
  type        = bool
  default     = true
  description = "Create default branch with first commit containing a README.md file"
}

variable "issues_enabled" {
  type        = bool
  default     = false
  description = "Enable issue tracking for the project"
}

variable "name" {
  type        = string
  description = "The name of the project"
}

variable "namespace" {
  type        = string
  description = "The namespace (group or user) of the project"
}

variable "only_allow_merge_if_all_discussions_are_resolved" {
  type        = bool
  default     = false
  description = "Set to true if you want allow merges only if all discussions are resolved."
}

variable "only_allow_merge_if_pipeline_succeeds" {
  type        = bool
  default     = false
  description = "Set to true if you want allow merges only if a pipeline succeeds."
}

variable "prevent_secrets" {
  type        = bool
  default     = true
  description = "GitLab rejects any files that are likely to contain secrets."
}

variable "reject_unsigned_commits" {
  type        = bool
  default     = true
  description = "GitLab rejects any unsigned commits."
}

variable "remove_source_branch_after_merge" {
  type        = bool
  default     = true
  description = "Enable \"Delete source branch\" option by default for all new merge requests."
}

variable "snippets_enabled" {
  type        = bool
  default     = false
  description = "Enable snippets for the project"
}

variable "squash_option" {
  type        = string
  default     = "default_off"
  description = "Squash commits when merge request"

  validation {
    condition     = contains(["default_off", "default_on", "never", "always"], var.squash_option)
    error_message = "The visibility value must be either \"never\",\"always\",\"default_on\" or \"default_off\"."
  }
}

variable "use_group_settings" {
  type        = bool
  default     = false
  description = "Ignore settings that can also be set on a group level to prevent conflicts"
}

variable "visibility" {
  type        = string
  default     = "private"
  description = "Set the GitLab project as public, private or internal"

  validation {
    condition     = contains(["internal", "private", "public"], var.visibility)
    error_message = "The visibility value must be either \"internal\", \"private\" or \"public\"."
  }
}

variable "wiki_enabled" {
  type        = bool
  default     = false
  description = "Enable wiki for the project"
}

variable "pipeline_schedule" {
  type = object({
    active         = optional(bool, true)
    cron           = string
    cron_timezone  = optional(string, "UTC")
    description    = string
    ref            = optional(string, "refs/heads/main")
    take_ownership = optional(bool, false)
  })
  default     = null
  description = "Pipeline scheduler parameter."

  validation {
    condition     = var.pipeline_schedule != null ? can((regex("^([0-5]?[0-9]|\\*) ([0-9]|1[0-9]|2[0-3]|\\*) ([1-9]|[12][0-9]|3[01]|\\*) ([1-9]|1[0-2]|\\*) ([0-6]|\\*)$", var.pipeline_schedule.cron))) : true
    error_message = "The cron expression is not valid. It should be in the format '0 1 * * *'."
  }
}
