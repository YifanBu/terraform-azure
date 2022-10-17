variable "number_of_machines" {
  type = number
  description = "This defines the number of virtual machines in the virtual network"
  default = 2  
}
variable "client_secret" {
  type        = string
  sensitive   = true
}