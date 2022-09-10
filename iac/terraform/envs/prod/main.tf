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
  # backend_service_plan_sku_name = "Y1"
  backend_function_always_on = false
}

module "core" {
  source = "../../modules/core"

  workload_name = var.workload_name
  env           = local.env
  # backend_service_plan_sku_name = local.backend_service_plan_sku_name
  backend_function_always_on = local.backend_function_always_on
}
