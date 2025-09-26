output "id" {
  value       = gitlab_project.default.id
  description = "Project ID"
}

output "http_url_to_repo" {
  value       = gitlab_project.default.http_url_to_repo
  description = "HTTP URL to the repository"
}

output "path" {
  value       = gitlab_project.default.path
  description = "Project path"
}

output "path_with_namespace" {
  value       = gitlab_project.default.path_with_namespace
  description = "Project path with namespace"
}

output "ssh_url_to_repo" {
  value       = gitlab_project.default.ssh_url_to_repo
  description = "SSH URL to the repository"
}

output "web_url" {
  value       = gitlab_project.default.web_url
  description = "Project web URL"
}
