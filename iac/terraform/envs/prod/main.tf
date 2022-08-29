terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "=3.19.1"
    }
  }

  backend "azurerm" {
    container_name = "tfstate"
    key            = "prod.terraform.tfstate"
  }
}

provider "azurerm" {
  features {}
}

locals {
  env = "prod"
}

module "backend" {
  source = "../../modules/backend"

  workload_name = var.workload_name
  env           = local.env
}
