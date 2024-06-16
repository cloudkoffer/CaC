################################################################################
# SOPS Age Key

resource "age_secret_key" "this" {}

resource "local_file" "this" {
  content = <<-EOT
  creation_rules:
    - path_regex: .*.yaml
      encrypted_regex: ^(data|stringData)$
      age: ${age_secret_key.this.public_key}
  EOT
  filename = "sops.yaml"
}

resource "kubernetes_namespace" "flux_system" {
  metadata {
    name = "flux-system"
  }
}

resource "kubernetes_secret" "sops_age" {
  metadata {
    name      = "sops-age"
    namespace = kubernetes_namespace.flux_system.metadata.0.name
  }

  data = {
    "age.agekey" = <<-EOT
    # created: 2024-01-01T00:00:00+01:00
    # public key: ${age_secret_key.this.public_key}
    ${age_secret_key.this.secret_key}
    EOT
  }
}

################################################################################
# Flux Bootstrap

resource "flux_bootstrap_git" "this" {
  path           = "cluster"
  version        = "v2.3.0" # https://github.com/fluxcd/flux2/releases
  log_level      = "info"   # debug, info, error
  network_policy = false

  depends_on = [
    kubernetes_secret.sops_age,
  ]
}
