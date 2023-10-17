variable "github_app" {
  description = "GitHub for API usages."

  type = object({
    # Is this the App ID?
    id         = string

    # This needs to be a base64-encoded string of the .pem file i.e. the output
    # of `base64 app.private-key.pem`.
    key_base64 = string # Isn't this sensitive?
  })

  sensitive = true
}
