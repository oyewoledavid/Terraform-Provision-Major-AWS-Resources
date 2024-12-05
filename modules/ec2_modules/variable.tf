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

variable "subnet_ids" {
  description = "List of subnet IDs"
  type        = string
}

variable "security_group_ids" {
  description = "List of security group IDs"
  type        = list(string)
  
}