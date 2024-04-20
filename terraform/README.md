# Talos / Deployment Flux / Terraform

## Prerequisite

### CLI tools

- terraform
- op

## Installation

- Configure environment variables.

  ``` shell
  CLOUDKOFFER="v3" # v1, v2, v3
  CLUSTER_NAME="talos-cloudkoffer-${CLOUDKOFFER}"
  FLUX_NAME="flux-cloudkoffer-${CLOUDKOFFER}"
  ```

- Initialise Terraform state

  ``` shell
  GITLAB_USER="$(op read "op://QAware-Showcases/GitLab - Talos - Project Access Token/username" --account=qawaregmbh)"
  GITLAB_TOKEN="$(op read "op://QAware-Showcases/GitLab - Talos - Project Access Token/password" --account=qawaregmbh)"

  # required by remote state datasource
  export TF_HTTP_USERNAME="${GITLAB_USER}"
  export TF_HTTP_PASSWORD="${GITLAB_TOKEN}"

  terraform init \
    -upgrade \
    -backend-config="address=https://gitlab.com/api/v4/projects/43783075/terraform/state/${FLUX_NAME}" \
    -backend-config="lock_address=https://gitlab.com/api/v4/projects/43783075/terraform/state/${FLUX_NAME}/lock" \
    -backend-config="unlock_address=https://gitlab.com/api/v4/projects/43783075/terraform/state/${FLUX_NAME}/lock" \
    -backend-config="username=${GITLAB_USER}" \
    -backend-config="password=${GITLAB_TOKEN}" \
    -backend-config="lock_method=POST" \
    -backend-config="unlock_method=DELETE" \
    -backend-config="retry_wait_min=5"
  ```

- Check and correct Terraform formatting if necessary.

  ``` shell
  terraform fmt -recursive
  ```

- Validate Terraform configuration.

  ``` shell
  terraform validate
  ```

- Execute a Terraform plan.

  ``` shell
  terraform plan -var="cluster_name=${CLUSTER_NAME}"
  ```

- Execute a Terraform apply.

  ``` shell
  terraform apply -var="cluster_name=${CLUSTER_NAME}"
  ```
