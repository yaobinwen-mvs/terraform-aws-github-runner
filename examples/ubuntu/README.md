# Action runners deployment ubuntu example

This module shows how to create GitHub action runners using an Ubuntu AMI. Lambda release will be downloaded from GitHub.

## Usages

Steps for the full setup, such as creating a GitHub app can be found in the root module's [README](../../README.md). First download the Lambda releases from GitHub. Alternatively you can build the lambdas locally with Node or Docker, there is a simple build script in `<root>/.ci/build.sh`. In the `main.tf` you can simply remove the location of the lambda zip files, the default location will work in this case.

> Ensure you have set the version in `lambdas-download/main.tf` for running the example. The version needs to be set to a GitHub release version, see [terraform-aws-github-runner/releases](https://github.com/philips-labs/terraform-aws-github-runner/releases). For example, if you want to use [`v4.5.1`](https://github.com/philips-labs/terraform-aws-github-runner/releases/tag/v4.5.1), then run the following commands:

```bash
cd ../lambdas-download
terraform init
terraform apply -var=module_version=v4.5.1
cd -
```

Then create `values.tfvars` and put the GitHub App's ID and base64 private key into the file as follows:

```terraform
github_app = {
  id = "409133"

  # See "Indented heredoc":
  # https://developer.hashicorp.com/terraform/language/expressions/strings#indented-heredocs
  key_base64 = <<-EOS
    LS0tLS1CRUdJTiBSU0EgUFJJVkFURSBLRVktLS0tLQpNSUlFcEFJQkFBS0NBUUVBMzNxKytXb1RU
    ...
    ...
    LUVORCBSU0EgUFJJVkFURSBLRVktLS0tLQo=
    EOS
}

```

Then run the following commands in the current folder to deploy the resources:

```bash
terraform init
terraform apply -var-file="values.tfvars"
```

The module will try to update the GitHub App webhook and secret (only linux/mac). Due to the sensitivity of the webhook secret, its value is not displayed on the screen:

```bash
Outputs:

runners = {
  "lambda_syncer_name" = "ubuntu-syncer"
}
webhook_endpoint = "https://uqg925fvqb.execute-api.xy-west-99.amazonaws.com/webhook"
webhook_secret = <sensitive>
```

You can receive the webhook details in clear text by running:

```bash
terraform output webhook_secret
```

<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.3.0 |
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | ~> 5.2 |
| <a name="requirement_local"></a> [local](#requirement\_local) | ~> 2.0 |
| <a name="requirement_random"></a> [random](#requirement\_random) | ~> 3.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_random"></a> [random](#provider\_random) | 3.5.1 |

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_base"></a> [base](#module\_base) | ../base | n/a |
| <a name="module_runners"></a> [runners](#module\_runners) | ../../ | n/a |
| <a name="module_webhook-github-app"></a> [webhook-github-app](#module\_webhook-github-app) | ../../modules/webhook-github-app | n/a |

## Resources

| Name | Type |
|------|------|
| [random_id.random](https://registry.terraform.io/providers/hashicorp/random/latest/docs/resources/id) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_github_app"></a> [github\_app](#input\_github\_app) | GitHub for API usages. | <pre>object({<br>    id         = string<br>    key_base64 = string<br>  })</pre> | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_runners"></a> [runners](#output\_runners) | n/a |
| <a name="output_webhook_endpoint"></a> [webhook\_endpoint](#output\_webhook\_endpoint) | n/a |
| <a name="output_webhook_secret"></a> [webhook\_secret](#output\_webhook\_secret) | n/a |
<!-- END_TF_DOCS -->
