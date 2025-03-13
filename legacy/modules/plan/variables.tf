variable "environment" {
  description = "The environment in which the resources are deployed"
  type        = string
}
variable "resource_group_name" {
  description = "The name of the resource group in which to create the resources."
  type        = string
}

variable "resource_group_location" {
  description = "The location/region of the resource group in which to create the resources."
  type        = string
}
