resource "aws_codebuild_project" "pr" {
  name           = "test_pull_request"
  description    = "test PR builds"
  build_timeout  = "5"
  queued_timeout = "5"

  service_role = aws_iam_role.example.arn

  artifacts {
    type = "NO_ARTIFACTS"
  }

  cache {
    type  = "LOCAL"
    modes = ["LOCAL_DOCKER_LAYER_CACHE", "LOCAL_SOURCE_CACHE"]
  }

  environment {
    compute_type                = "BUILD_GENERAL1_SMALL"
    image                       = "aws/codebuild/standard:1.0"
    type                        = "LINUX_CONTAINER"
    image_pull_credentials_type = "CODEBUILD"

    environment_variable {
      name  = "SOME_KEY1"
      value = "SOME_VALUE1"
    }
  }
  badge_enabled = true

  source {
    type            = "CODECOMMIT"
    location        = data.aws_codecommit_repository.repo.clone_url_http
  }

  tags = {
    Environment = "Test"
  }
}

data "aws_codecommit_repository" "repo" {
    repository_name = "pr_test"
}