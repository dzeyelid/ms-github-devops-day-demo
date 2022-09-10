variable "workload_name" {
  type = string
}

variable "env" {
  type    = string
  default = "dev"
}

variable "backend_service_plan_sku_name" {
  type    = string
  default = "Y1"
}
