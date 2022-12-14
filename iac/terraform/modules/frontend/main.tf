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
    "linked_backend_resource_id" = {
      value = var.linked_backend_resource_id
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
      "type": "String"
    },
    "linked_backend_resource_id": {
      "type": "String"
    },
    "staticSiteName": {
      "type": "String"
    }
  },
  "variables": {},
  "resources": [
    {
      "type": "Microsoft.Web/staticSites/linkedBackends",
      "apiVersion": "2022-03-01",
      "name": "[concat(parameters('staticSiteName'), '/backend-api')]",
      "properties": {
        "backendResourceId": "[parameters('linked_backend_resource_id')]",
        "region": "[parameters('region')]"
      }
    }
  ]
}
TEMPLATE
}
