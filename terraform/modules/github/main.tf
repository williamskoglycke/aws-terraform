provider "github" {
  token = var.github_token
}

resource "github_repository" "my_repository" {
  name        = var.repository_name
  description = "Server repository name"
  visibility  = "public"
}

resource "github_actions_secret" "aws_access_key_id" {
  repository      = github_repository.my_repository.id
  secret_name     = "AWS_ACCESS_KEY_ID"
  plaintext_value = var.aws_access_key
}

resource "github_actions_secret" "aws_secret_access_key" {
  repository      = github_repository.my_repository.id
  secret_name     = "AWS_SECRET_ACCESS_KEY"
  plaintext_value = var.aws_secret_key
}

resource "github_actions_secret" "aws_role_to_assume" {
  repository      = github_repository.my_repository.id
  secret_name     = "AWS_ROLE_TO_ASSUME"
  plaintext_value = var.aws_role_to_assume
}

resource "github_actions_secret" "aws_role_external_id" {
  repository      = github_repository.my_repository.id
  secret_name     = "AWS_ROLE_EXTERNAL_ID"
  plaintext_value = var.aws_role_external_id
}

resource "github_branch_protection" "main" {
  repository_id  = github_repository.my_repository.id
  pattern        = "main"
  enforce_admins = true

  required_pull_request_reviews {
    dismiss_stale_reviews           = true
    require_code_owner_reviews      = true
    required_approving_review_count = 2
  }

  required_status_checks {
    strict = true
    contexts = ["ci/build", "cd/build-and-deploy"]
  }
}

resource "github_branch_protection" "develop" {
  repository_id  = github_repository.my_repository.id
  pattern        = "develop"
  enforce_admins = true

  required_pull_request_reviews {
    dismiss_stale_reviews           = true
    require_code_owner_reviews      = true
    required_approving_review_count = 2
  }

  required_status_checks {
    strict = true
    contexts = ["ci/build"]
  }
}
