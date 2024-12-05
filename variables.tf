variable "vpc_cidr_block" {
  description = "value of the CIDR block"
}

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


variable "nat_gateway_id" {
  description = "The NAT Gateway ID for private route tables"
  type        = string
  
}
variable "internet_gateway_id" {
  description = "The Internet Gateway ID for public route tables"
  type        = string
  
}

variable "route_table_config" {
  description = "Configuration for the route tables"
  type = map(object({
    name       = string
    is_public  = bool
  }))
}

variable "route_table_cidr_block" {
  description = "value of the route table cidr block"
  
}

variable "destination_cidr_block" {
  description = "value of the destination cidr block"
  
}

variable "subnet_ids" {
  description = "List of subnet IDs"
  type        = list(string)
  
}

variable "ami" {
  type        = string
  description = "value of the AMI"
  
}
variable "instance_type" {
  type        = string
  description = "value of the instance type"
}
variable "key_name" {
  type        = string
  description = "value of the key name"
}
variable "eip_ids" {
  description = "List of Elastic IP IDs"
  type        = list(string)
  
}

variable "security_group_ids" {
  description = "List of security group IDs"
  type        = list(string)
  
}
variable "instances" {
  description = "List of private instances"
  type        = list(string)
  
}