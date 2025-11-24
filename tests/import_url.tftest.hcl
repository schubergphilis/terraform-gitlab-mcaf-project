mock_provider "gitlab" {
  mock_data "gitlab_group" {
    defaults = {
      id = "12345"
    }
  }

  mock_data "gitlab_user" {
    defaults = {
      id = "67890"
    }
  }
}

run "setup" {
  module {
    source = "./tests/setup"
  }
}

run "import_url" {
  variables {
    name       = "basic-${run.setup.random_string}"
    namespace  = "basic-${run.setup.random_string}"
    import_url = "https://example.com/repo.git"
  }

  module {
    source = "./"
  }

  command = plan

  assert {
    condition     = resource.gitlab_project.default.import_url == "https://example.com/repo.git"
    error_message = "Expected import_url to be: \"https://example.com/repo.git\", got: \"${resource.gitlab_project.default.import_url}\""
  }
}

run "import_url_with_credentials" {
  variables {
    name                = "basic-${run.setup.random_string}"
    namespace           = "basic-${run.setup.random_string}"
    import_url          = "https://example.com/repo.git"
    import_url_username = "user"
    import_url_password = "password"
  }

  module {
    source = "./"
  }

  command = plan

  assert {
    condition     = resource.gitlab_project.default.import_url == "https://example.com/repo.git"
    error_message = "Expected import_url to be: \"https://example.com/repo.git\", got: \"${resource.gitlab_project.default.import_url}\""
  }

  assert {
    condition     = resource.gitlab_project.default.import_url_username == "user"
    error_message = "Expected import_url_username to be: \"user\", got: \"${resource.gitlab_project.default.import_url_username}\""
  }

  assert {
    condition     = resource.gitlab_project.default.import_url_password == "password"
    error_message = "Expected import_url_password to be: \"password\", got: \"${nonsensitive(resource.gitlab_project.default.import_url_password)}\""
  }
}

run "import_url_with_mirror_true" {
  variables {
    name       = "basic-${run.setup.random_string}"
    namespace  = "basic-${run.setup.random_string}"
    import_url = "https://example.com/repo.git"
    mirror     = true
  }

  module {
    source = "./"
  }

  command = plan

  assert {
    condition     = resource.gitlab_project.default.import_url == "https://example.com/repo.git"
    error_message = "Expected import_url to be: \"https://example.com/repo.git\", got: \"${resource.gitlab_project.default.import_url}\""
  }

  assert {
    condition     = resource.gitlab_project.default.mirror == true
    error_message = "Expected mirror to be: true, got: \"${resource.gitlab_project.default.mirror}\""
  }
}

run "mirror_true_without_import_url" {
  variables {
    name      = "basic-${run.setup.random_string}"
    namespace = "basic-${run.setup.random_string}"
    mirror    = true
  }

  module {
    source = "./"
  }

  command = plan

  expect_failures = [
    var.mirror,
  ]
}
