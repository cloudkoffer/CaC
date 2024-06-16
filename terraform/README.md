# Talos / Deployment Flux / Terraform

## Prerequisite

### CLI tools

- terraform

## Installation

- Configure environment variables.

  ``` shell
  CLOUDKOFFER=v3 # v1, v2, v3
  CLUSTER_NAME="talos-cloudkoffer-${CLOUDKOFFER}"
  ```

- Initialise Terraform state.

  ``` shell
  terraform init -upgrade
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
