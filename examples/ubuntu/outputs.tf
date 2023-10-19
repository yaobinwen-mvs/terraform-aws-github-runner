output "runners" {
  value = {
    lambda_syncer_name = module.runners.binaries_syncer.lambda.function_name
  }
}

output "webhook_endpoint" {
  value = module.runners.webhook.endpoint
}

output "webhook_secret" {
  # NOTE(ywen): The webhook secret is not displayed in the output of
  # `terraform apply` but running `terraform output -raw webhook_secret` can
  # display the value.
  sensitive = true
  value     = random_id.random.hex
}

