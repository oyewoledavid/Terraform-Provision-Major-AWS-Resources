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
# variable "public_1a_cidr_block" {
#   description = "value of the public 1a cidr block"
  
# }
# variable "public_1a_availability_zone" {
#   description = "value of the public 1a availability zone"
  
# }

# variable "public_1b_cidr_block" {
#   description = "value of the public 1b cidr block"
  
# }

# variable "public_1b_availability_zone" {
#   description = "value of the public 1b availability zone"
  
# }

# variable "private_1a_cidr_block" {
#   description = "value of the private 1a cidr block"
  
# }

# variable "private_1a_availability_zone" {
#   description = "value of the private 1a availability zone"
  
# }