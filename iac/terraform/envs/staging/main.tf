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

provider "azurerm" {
  features {}
}

locals {
  env                           = "staging"
  backend_service_plan_sku_name = "Y1"
}

module "core" {
  source = "../../modules/core"

  workload_name                 = var.workload_name
  env                           = local.env
  backend_service_plan_sku_name = local.backend_service_plan_sku_name
}
