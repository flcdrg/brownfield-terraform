variable "environment" {
  description = "The environment to deploy to"
  type        = string
  default     = "dev"
}
variable "resourcegroup_name" {
  description = "The name of the resource group"
  type        = string
}