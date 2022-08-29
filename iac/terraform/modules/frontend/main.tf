data "azurerm_resource_group" "shared" {
  name = "rg-${var.workload_name}-${var.env}"
}

resource "azurerm_static_site" "frontend" {
  name                = "stapp-${var.workload_name}-${var.env}"
  resource_group_name = data.azurerm_resource_group.shared.name
  location            = "eastasia"
  sku_tier            = "Standard"
  sku_size            = "Standard"
}

resource "azurerm_resource_group_template_deployment" "frontend" {
  name                = "linkedBackendDeploy"
  resource_group_name = data.azurerm_resource_group.shared.name
  deployment_mode     = "Incremental"
  parameters_content = jsonencode({
    "region" = {
      value = data.azurerm_resource_group.shared.location
    }
    "backendResourceId" = {
      value = var.backendResourceId
    }
    "staticSiteName" = {
      value = azurerm_static_site.frontend.name
    }
  })
  template_content = <<TEMPLATE
{
  "$schema": "https://schema.management.azure.com/schemas/2019-04-01/deploymentTemplate.json#",
  "contentVersion": "1.0.0.0",
  "parameters": {
    "region": {
      "type": "string"
    },
    "backendResourceId": {
      "type": "string"
    },
    "staticSiteName": {
      "type": "string"
    }
  },
  "variables": {},
  "resources": [
    {
      "type": "Microsoft.Web/staticSites/linkedBackends",
      "apiVersion": "2022-03-01",
      "name": "[concat(parameters('staticSiteName'), '/backend-api')]",
      "properties": {
        "backendResourceId": "[parameters('backendResourceId')]",
        "region": "[parameters('region')]"
      }
    }
  ]
}
TEMPLATE
}
