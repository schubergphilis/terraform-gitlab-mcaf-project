output "path_with_namespace" {
  value       = gitlab_project.default.path_with_namespace
  description = "GitLab project path with namespace"
}

output "path" {
  value       = gitlab_project.default.path
  description = "GitLab project path"
}

output "id" {
  value       = gitlab_project.default.id
  description = "GitLab project id"
}
