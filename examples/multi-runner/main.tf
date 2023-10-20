locals {
  environment = var.environment != null ? var.environment : "multi-runner"
  aws_region  = "us-east-2"

  # Load runner configurations from Yaml files
  multi_runner_config = { for c in fileset("${path.module}/templates/runner-configs", "*.yaml") : trimsuffix(c, ".yaml") => yamldecode(file("${path.module}/templates/runner-configs/${c}")) }
}

resource "random_id" "random" {
  byte_length = 20
}

module "base" {
  source = "../base"

  prefix     = local.environment
  aws_region = local.aws_region
}

module "multi-runner" {
  source                            = "../../modules/multi-runner"
  multi_runner_config               = local.multi_runner_config
  aws_region                        = local.aws_region
  vpc_id                            = module.base.vpc.vpc_id
  subnet_ids                        = module.base.vpc.private_subnets
  runners_scale_up_lambda_timeout   = 60
  runners_scale_down_lambda_timeout = 60
  prefix                            = local.environment
  tags = {
    Project = "ProjectX"
  }
  github_app = {
    key_base64     = var.github_app.key_base64
    id             = var.github_app.id
    webhook_secret = random_id.random.hex
  }

  # Assuming local build lambda's to use pre build ones, uncomment the lines below and download the
  # lambda zip files lambda_download
  webhook_lambda_zip                = "../lambdas-download/webhook.zip"
  runner_binaries_syncer_lambda_zip = "../lambdas-download/runner-binaries-syncer.zip"
  runners_lambda_zip                = "../lambdas-download/runners.zip"

  # Per ../../README.md:
  #
  # > This queue is an experimental feature to allow you to receive a copy of
  # > the wokflow_jobs events sent by the GItHub App. For example to calculate
  # > a matrix or monitor the system.
  #
  # NOTE(ywen): I don't think we need to enable it.
  # enable_workflow_job_events_queue = true

  # Enable debug logging for the lambda functions
  log_level = "debug"
}

module "webhook-github-app" {
  source     = "../../modules/webhook-github-app"
  depends_on = [module.multi-runner]

  github_app = {
    key_base64     = var.github_app.key_base64
    id             = var.github_app.id
    webhook_secret = random_id.random.hex
  }
  webhook_endpoint = module.multi-runner.webhook.endpoint
}
