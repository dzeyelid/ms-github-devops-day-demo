terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "=3.19.1"
    }
  }

  backend "azurerm" {
    container_name = "tfstate"
    key            = "staging.terraform.tfstate"
  }
}

# Configure the Microsoft Azure Provider
provider "azurerm" {
  features {}
}

locals {
  env = "staging"
}

module "backend" {
  source = "../../modules/backend"

  workload_name = var.workload_name
  env           = local.env
}
