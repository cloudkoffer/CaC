# Talos / Deployment Flux / Manual

## Prerequisite

### CLI tools

- age
- kubectl
- flux

## Installation

- Create SOPS age key.

  ``` shell
  if [ ! -f "age.key" ]; then
    age-keygen --output age.key
  fi
  ```

- Create SOPS configuration.

  ``` shell
  cat <<EOF > sops.yaml
  creation_rules:
    - path_regex: .*.yaml
      encrypted_regex: ^(data|stringData)$
      age: $(age-keygen -y age.key)
  EOF
  ```

- Create SOPS Kubernetes secret.

  ``` shell
  kubectl create namespace flux-system &>/dev/null || true
  kubectl create secret generic sops-age \
    --namespace=flux-system \
    --from-file=age.key
  ```

- Bootstrap flux

  ``` shell
  export GITHUB_TOKEN=<my-token>

  # https://fluxcd.io/flux/cmd/flux_bootstrap_github/
  flux bootstrap github \
    --owner=cloudkoffer \
    --repository=gitops-flux\
    --path=cluster \
    --token-auth
  ```
