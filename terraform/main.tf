################################################################################
# SOPS Age Key

resource "kubernetes_namespace" "flux_system" {
  metadata {
    name = "flux-system"
  }
}

resource "age_secret_key" "this" {}

resource "local_file" "this" {
  content = templatefile("tftpl/.sops.yaml",
    {
      public_key = age_secret_key.this.public_key,
    }
  )
  filename = "../../deployment-stack/configs/${var.cluster_name}.sops.yaml"
}

resource "kubernetes_secret" "sops_age" {
  metadata {
    name      = "sops-age"
    namespace = kubernetes_namespace.flux_system.metadata.0.name
  }

  data = {
    "age.agekey" = templatefile("tftpl/age.agekey",
      {
        public_key = age_secret_key.this.public_key,
        secret_key = age_secret_key.this.secret_key,
      }
    )
  }
}

################################################################################
# GitHub Deploy Key and Flux Bootstrap

resource "tls_private_key" "this" {
  algorithm = "ED25519"
}

data "github_repository" "this" {
  name = "cloud-native-explab"
}

resource "github_repository_deploy_key" "this" {
  title      = var.cluster_name
  repository = data.github_repository.this.name
  key        = tls_private_key.this.public_key_openssh
  read_only  = false
}

resource "flux_bootstrap_git" "this" {
  path           = "clusters/bare/${var.cluster_name}"
  interval       = "1m0s"
  version        = "v2.0.0-rc.5" # https://github.com/fluxcd/flux2/releases
  log_level      = "info"        # debug, info, error
  network_policy = false

  depends_on = [
    github_repository_deploy_key.this,
    kubernetes_secret.sops_age,
  ]
}
