variable "op_account" {
  description = "The 1password account"
}

variable "op_vault" {
  description = "The 1password vault"
}

variable "op_ssh_key" {
  description = "The name of the 1password SSH key secret"
}

locals {
  hostname = "thisistheremix.dev"
  ssh_host = "lil-nas-x.local"
  letsencrypt_email = "josh.holbrook@gmail.com"
}

terraform {
  required_version = ">= 1.7.2"

  required_providers {
    onepassword = {
      source = "1Password/onepassword"
      version = "2.1.2"
    }

    dokku = {
      source  = "registry.terraform.io/aliksend/dokku"
      version = "~> 1.0.22"
    }

    shell = {
      source = "scottwinkler/shell"
      version = "1.7.10"
    }

    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }

  backend "s3" {
    bucket = "jfhbrook-terraform-state"
    key    = "wholesomecoolness.tfstate"
    region = "us-west-2"

    dynamodb_table = "terraform-locks"
    encrypt        = true
  }
}

provider "onepassword" {
  account = var.op_account
}

data "onepassword_item" "ssh_key" {
  vault = var.op_vault
  title = var.op_ssh_key
}

provider "dokku" {
  ssh_host = local.ssh_host
  ssh_cert = data.onepassword_item.ssh_key.private_key
}

module "app" {
  source = "git::ssh://git@github.com/jfhbrook/tf-modules//dokku-deployment?ref=v1.1.0"

  hostname = local.hostname
  ssh_host = local.ssh_host

  letsencrypt = {
    enable = false
    email = local.letsencrypt_email
  }
}

output "app_name" {
  value = module.app.app_name
}

output "app_url" {
  value = module.app.app_url
}
