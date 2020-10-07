variable "region" {
  default = "us-east-1"
}
variable "vpc_cidr" {
  default     = "10.0.0.0/16"
  type        = string
  description = "choose cidr for vpc"
}

variable "subnet_cidr1" {
  default     = "10.0.1.0/24"
  description = "choose cidr for subnet1"
}

variable "azs" {
  default = ["us-east-1a", "us-east-1b", "us-east-1c"]
}

variable "web_ami" {
  default = {
    us-east-1  = "ami-0c94855ba95c71c99"
    ap-south-1 = "ami-0c94855ba95c71c88"
  }
}
