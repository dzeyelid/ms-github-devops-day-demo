module "backend" {
  source = "../backend"

  workload_name = var.workload_name
  env           = var.env
}

module "frontend" {
  source = "../frontend"

  workload_name     = var.workload_name
  env               = var.env
  backendResourceId = module.backend.functionResourceId
}
