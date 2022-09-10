module "backend" {
  source = "../backend"

  workload_name         = var.workload_name
  env                   = var.env
  service_plan_sku_name = var.backend_service_plan_sku_name
}

module "frontend" {
  source = "../frontend"

  workload_name              = var.workload_name
  env                        = var.env
  linked_backend_resource_id = module.backend.functionResourceId
}
