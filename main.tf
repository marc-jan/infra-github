terraform {
    required_providers {
        github = {
            source  = "integrations/github"
            version = "~> 4.0"
        }
    }
}

provider "github" {
    token = var.github_token
    owner = var.organization_name
}

data "github_organization" "axxs" {
    name = var.organization_name
}
