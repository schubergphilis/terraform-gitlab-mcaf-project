variable "approvals_before_merge" {
  type        = number
  default     = 1
  description = "Number of merge request approvals required for merging"
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

variable "snippets_enabled" {
  type        = bool
  default     = false
  description = "Enable snippets for the project"
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
