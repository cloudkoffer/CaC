# Talos / Deployment Flux / Terraform

## Prerequisite

### CLI tools

- terraform

## Installation

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
  export TF_VAR_github_token=<github-token>
  terraform plan
  ```

- Execute a Terraform apply.

  ``` shell
  export TF_VAR_github_token=<github-token>
  terraform apply
  ```
