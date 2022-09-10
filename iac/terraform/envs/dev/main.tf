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
  # backend_service_plan_sku_name = var.backend_service_plan_sku_name
  backend_function_always_on = var.backend_function_always_on
}
