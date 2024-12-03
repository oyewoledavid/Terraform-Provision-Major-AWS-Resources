variable "vpc_id" {
  description = "The VPC ID for the route tables"
  type        = string
}

variable "internet_gateway_id" {
  description = "The Internet Gateway ID for public route tables"
  type        = string
  default     = null
}

variable "route_table_config" {
  description = "Configuration for the route tables"
  type = map(object({
    name       = string
    is_public  = bool
  }))
}

variable "destination_cidr_block" {
  description = "value of the destination cidr block"
  
}

variable "nat_gateway_id" {
  description = "The NAT Gateway ID for private route tables"
  type        = string
}

# variable "route_table_cidr_block" {
#   description = "value of the route table cidr block"
  
# }

# variable "vpc_id" {
#   description = "value of the vpc id"
#   type        = string
  
# }