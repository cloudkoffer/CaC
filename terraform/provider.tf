terraform {
  required_providers {
    # https://github.com/clementblaise/terraform-provider-age/blob/main/CHANGELOG.md
    age = {
      source  = "clementblaise/age"
      version = "~> 0.1.1"
    }
    # https://github.com/hashicorp/terraform-provider-local/blob/main/CHANGELOG.md
    local = {
      source  = "hashicorp/local"
      version = "~> 2.4.0"
    }
    # https://github.com/hashicorp/terraform-provider-kubernetes/blob/main/CHANGELOG.md
    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = "~> 2.21.1"
    }
    # https://github.com/hashicorp/terraform-provider-tls/blob/main/CHANGELOG.md
    tls = {
      source  = "hashicorp/tls"
      version = "~> 4.0.4"
    }
    # https://github.com/integrations/terraform-provider-github/releases
    github = {
      source  = "integrations/github"
      version = "~> 5.26.0"
    }
    # https://github.com/fluxcd/terraform-provider-flux/blob/main/CHANGELOG.md
    flux = {
      source  = "fluxcd/flux"
      version = "1.0.0-rc.5"
    }
  }

  backend "http" {}
}

data "terraform_remote_state" "talos" {
  backend = "http"

  config = {
    address = "https://gitlab.com/api/v4/projects/43783075/terraform/state/${var.cluster_name}"
  }
}

provider "kubernetes" {
  client_certificate     = base64decode(data.terraform_remote_state.talos.outputs.kubeconfig.client_certificate)
  client_key             = base64decode(data.terraform_remote_state.talos.outputs.kubeconfig.client_key)
  cluster_ca_certificate = base64decode(data.terraform_remote_state.talos.outputs.kubeconfig.ca_certificate)
  host                   = data.terraform_remote_state.talos.outputs.kubeconfig.host
}

provider "github" {
  owner = "qaware"
  token = var.github_token
}

provider "flux" {
  kubernetes = {
    client_certificate     = base64decode(data.terraform_remote_state.talos.outputs.kubeconfig.client_certificate)
    client_key             = base64decode(data.terraform_remote_state.talos.outputs.kubeconfig.client_key)
    cluster_ca_certificate = base64decode(data.terraform_remote_state.talos.outputs.kubeconfig.ca_certificate)
    host                   = data.terraform_remote_state.talos.outputs.kubeconfig.host
  }

  git = {
    url    = "ssh://git@github.com/${data.github_repository.this.full_name}.git"
    branch = "cloudkoffer"
    ssh = {
      username    = "git"
      private_key = tls_private_key.this.private_key_pem
    }
  }
}
