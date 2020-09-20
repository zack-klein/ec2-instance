variable "region" {
  type        = string
  description = "AWS Region"
  default     = "us-east-1"
}

variable "ami" {
  type        = string
  description = "ID of the AMI."
  default     = "ami-02354e95b39ca8dec"
}

variable "instance_name" {
  type        = string
  description = "Semantic name for the instances and related resources."
  default     = "public-asg"
}

variable "instance_type" {
  type        = string
  default     = "t2.micro"
  description = "Type of instance."
}

variable "min_size" {
  type        = number
  description = "Minimum size of the auto-scaling group."
  default     = 1
}

variable "max_size" {
  type        = number
  description = "Maximum size of the auto-scaling group."
  default     = 1
}

variable "user_data" {
  description = "User data to bootstrap the instance."
}

variable "public" {
  type        = bool
  default     = false
  description = "True/False expose this instance on the public internet. NOTE: This is just for security groups."
}

variable "vpc_id" {
  type        = string
  description = "ID of the VPC to launch the instance into."
}

variable "subnets" {
  type        = list
  description = "List of subnets for the auto scaling group."
}

variable "ssh_public_key" {
  type        = string
  description = "Public key of the SSH key to use for SSH'ing into the instances."
}

variable "instance_profile" {
  type        = string
  default     = null
  description = "Name of an instance profile to attach."
}

variable "target_group_arns" {
  type        = list
  default     = null
  description = "ARN's of target groups to attach to instances (you'll want to use this if you're using a load balancer)."
}

# Allow access from work station IP

data "http" "workstation-external-ip" {
  url = "http://ipv4.icanhazip.com"
}

locals {
  workstation-cidr = "${chomp(data.http.workstation-external-ip.body)}/32"
}

locals {
  https-cidr = var.public ? ["0.0.0.0/0"] : [local.workstation-cidr]
  ssh-cidr   = [local.workstation-cidr]
}
