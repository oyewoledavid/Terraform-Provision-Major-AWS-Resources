variable "ami" {
  default     = "ami-0e001c9271cf7f3b9"
  type        = string
  description = "value of the AMI"

}

variable "key" {
  default     = "Test"
  description = "value of the key"
  type        = string
}

variable "vpc_id" {
  default = "aws_vpc.main-vpc.id"
}