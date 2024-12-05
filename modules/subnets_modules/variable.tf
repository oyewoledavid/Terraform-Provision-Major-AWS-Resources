variable "subnet_cidrs" {
  description = "List of subnet CIDR blocks"
  type        = list(string)
}

variable "availability_zones" {
  description = "List of availability zones"
  type        = list(string)
}

variable "vpc_id" {
  description = "value of the vpc id"
  type        = string
  
}