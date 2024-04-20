variable "cluster_name" {
  description = "The name for the Talos cluster."
  type        = string
  nullable    = false
}

variable "github_token" {
  description = "The personal access token to authenticate to GitHub."
  type        = string
  nullable    = false
}
