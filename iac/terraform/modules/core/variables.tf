variable "workload_name" {
  type = string
}

variable "env" {
  type = string
}

variable "backend_service_plan_sku_name" {
  type    = string
  default = "P1v2"
}
