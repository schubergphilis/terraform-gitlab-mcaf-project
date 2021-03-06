variable "approvals_before_merge" {
  type        = number
  default     = 1
  description = "Number of merge request approvals required for merging"
}

variable "branch_protection" {
  type = map(object({
    push_access_level            = string
    merge_access_level           = string
    code_owner_approval_required = bool
  }))
  default     = null
  description = "Branch protection settings"
}

variable "default_branch" {
  type        = string
  default     = "master"
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
