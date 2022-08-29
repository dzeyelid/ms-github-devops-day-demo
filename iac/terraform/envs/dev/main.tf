terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "=3.19.1"
    }
  }

  backend "azurerm" {
    container_name = "tfstate"
    key            = "dev.terraform.tfstate"
  }
}

provider "azurerm" {
  features {}
}

module "core" {
  source = "../../modules/core"

  workload_name = var.workload_name
  env           = var.env
}
