variable "subnet_ids" {
  description = "List of subnet IDs"
  type        = string
}
variable "eip_ids" {
  description = "List of Elastic IP IDs"
  type        = list(string)
  
}
