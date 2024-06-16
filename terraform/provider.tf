terraform {
  required_providers {
    # https://github.com/clementblaise/terraform-provider-age/blob/main/CHANGELOG.md
    age = {
      source  = "clementblaise/age"
      version = "0.1.1"
    }
    # https://github.com/hashicorp/terraform-provider-local/blob/main/CHANGELOG.md
    local = {
      source  = "hashicorp/local"
      version = "2.5.1"
    }
    # https://github.com/hashicorp/terraform-provider-kubernetes/blob/main/CHANGELOG.md
    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = "2.30.0"
    }
    # https://github.com/integrations/terraform-provider-github/releases
    github = {
      source  = "integrations/github"
      version = "6.2.1"
    }
    # https://github.com/fluxcd/terraform-provider-flux/blob/main/CHANGELOG.md
    flux = {
      source  = "fluxcd/flux"
      version = "1.3.0"
    }
  }
}

provider "kubernetes" {
  config_path = "~/.kube/config"
}

provider "github" {
  owner = "cloudkoffer"
  token = var.github_token
}

provider "flux" {
  kubernetes = {
    config_path = "~/.kube/config"
  }

  git = {
    url = "https://github.com/cloudkoffer/gitops-flux.git"
    http = {
      username = "git"
      password = var.github_token
    }
  }
}
