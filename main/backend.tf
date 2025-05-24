# This is the workspace configuration defined in terraform.io
terraform {
  backend "remote" {
    organization = "your-organization-name"

    workspaces {
      name = "your-workspace-name"
    }
  }
}
