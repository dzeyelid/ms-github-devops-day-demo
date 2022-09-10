data "azurerm_resource_group" "shared" {
  name = "rg-${var.workload_name}-${var.env}"
}

resource "random_string" "backend_func_storage" {
  length  = 18
  special = false
  upper   = false
  keepers = {
    resource_group_id = data.azurerm_resource_group.shared.id
    module            = "backend"
    target            = "function"
  }
}

resource "azurerm_log_analytics_workspace" "backend" {
  name                = "log-${var.workload_name}-${var.env}"
  location            = data.azurerm_resource_group.shared.location
  resource_group_name = data.azurerm_resource_group.shared.name
  sku                 = "PerGB2018"
  retention_in_days   = 30
}

resource "azurerm_application_insights" "backend" {
  name                = "appi-${var.workload_name}-${var.env}-backend"
  resource_group_name = data.azurerm_resource_group.shared.name
  location            = data.azurerm_resource_group.shared.location
  workspace_id        = azurerm_log_analytics_workspace.backend.id
  application_type    = "web"
}

resource "azurerm_storage_account" "backend_func" {
  name                     = "st${random_string.backend_func_storage.result}func"
  resource_group_name      = data.azurerm_resource_group.shared.name
  location                 = data.azurerm_resource_group.shared.location
  account_tier             = "Standard"
  account_replication_type = "LRS"
}

resource "azurerm_service_plan" "backend" {
  name                = "plan-${var.workload_name}-${var.env}-backend"
  resource_group_name = data.azurerm_resource_group.shared.name
  location            = data.azurerm_resource_group.shared.location
  os_type             = "Windows"
  sku_name            = var.service_plan_sku_name
}

resource "azurerm_windows_function_app" "backend" {
  name                       = "func-${var.workload_name}-${var.env}-backend"
  resource_group_name        = data.azurerm_resource_group.shared.name
  location                   = data.azurerm_resource_group.shared.location
  storage_account_name       = azurerm_storage_account.backend_func.name
  storage_account_access_key = azurerm_storage_account.backend_func.primary_access_key
  service_plan_id            = azurerm_service_plan.backend.id

  https_only                  = true
  functions_extension_version = "~4"

  site_config {
    always_on = var.function_always_on || (var.service_plan_sku_name != "Y1")
    application_stack {
      node_version = "~16"
    }
    ftps_state                             = "Disabled"
    http2_enabled                          = true
    application_insights_key               = azurerm_application_insights.backend.instrumentation_key
    application_insights_connection_string = azurerm_application_insights.backend.connection_string
  }
}
