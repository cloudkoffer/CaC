# Talos / Deployment Flux / Manual

## Prerequisite

### CLI tools

- age
- kubectl
- flux

## Installation

- Configure environment variables.

  ``` shell
  CLOUDKOFFER=v3 # v1, v2, v3
  CLUSTER_NAME="talos-cloudkoffer-${CLOUDKOFFER}"
  ```

- Create SOPS age key.

  ``` shell
  if [ ! -f "configs/${CLUSTER_NAME}.agekey" ]; then
    age-keygen --output "configs/${CLUSTER_NAME}.agekey"
  fi
  ```

- Create SOPS configuration.

  ``` shell
  cat <<EOF > "../../deployment-stack/configs/${CLUSTER_NAME}.sops.yaml"
  creation_rules:
    - path_regex: .*.yaml
      encrypted_regex: ^(data|stringData)$
      age: $(age-keygen -y "configs/${CLUSTER_NAME}.agekey")
  EOF
  ```

- Create SOPS Kubernetes secret.

  ``` shell
  kubectl create namespace flux-system &>/dev/null || true
  kubectl create secret generic sops-age \
    --namespace=flux-system \
    --from-file="configs/${CLUSTER_NAME}.agekey" \
    --dry-run=client \
    --output=yaml \
    --save-config | \
  kubectl apply -f -
  ```

- Bootstrap flux

  ``` shell
  # Needs 'Admin' role on the repository 'cloud-native-explab'
  export GITHUB_TOKEN=<my-token>

  # https://fluxcd.io/flux/cmd/flux_bootstrap_github/
  flux bootstrap github \
    --owner=qaware \
    --repository=cloud-native-explab \
    --branch=cloudkoffer \
    --path="clusters/bare/${CLUSTER_NAME}" \
    --read-write-key
  ```
