variable "cloudflare_account_id" {
  type    = string
  default = "REPLACE_WITH_YOUR_CLOUDFLARE_ACCOUNT_ID"
}
variable "env" {
  type = string
  default = "opentofu"
}

variable "cloudflare_app_name" {
  type    = string
  default = "internalwebapp"
}

variable "tags" {
  description = "A map of tags (key-value pairs) passed to resources."
  type        = map(string)
  default     = {}
}

variable "cloudflare_app_logo" {
  description = "The logo of the Cloudflare Access application"
  type        = string
  default     = "https://cf-assets.www.cloudflare.com/zkvhlag99gkb/5BaCrrFNjkAebdQOoEvU4y/5c115841c5f41cbb165a4cda49b81192/image3-16.png"
}


variable "cloudflare_zone_id" {
  type    = string
  default = "REPLACE_WITH_YOUR_CLOUDFLARE_ZONE_ID"
}

variable "tunnel_name" {
  description = "The name of the Cloudflare Tunnel"
  type        = string
  default     = "internalwebapp"
}

variable "tunnel_dnsname" {
  description = "The DNS name of the Cloudflare Tunnel"
  type        = string
  default     = "internalwebapp"
}

variable "tunnel_hostname" {
  description = "The hostname of the Cloudflare Tunnel"
  type        = string
  default     = "internal.example.com"
}

variable "tunnel_origin" {
  description = "The URL of the origin monitored by Cloudflare Tunnel"
  type        = string
  default     = "http://internalwebapp:8080"
}

variable "prefix" {
  type    = string
  default = "internalwebapp"
}

variable "instance_type" {
  description = "The instance type for the EC2 instance"
  type        = string
  default     = "t2.micro"
}

variable "instance_key_name" {
  description = "The key name for the EC2 instance"
  type        = string
  default     = null
}

variable "instance_state" {
  description = "The state of the EC2 instance"
  type        = string
  default     = "running"
}

variable "vpc_cidr" {
  description = "The CIDR block for the VPC"
  type        = string
  default     = "10.0.0.0/28"
}

variable "vpc_enable_dns_hostnames" {
  description = "A boolean flag to enable/disable DNS hostnames in the VPC"
  type        = bool
  default     = true
}

variable "public_subnet_cidr" {
  description = "The CIDR block for the public subnet"
  type        = string
  default     = "10.0.0.0/28"
}

variable "private_subnet_cidr" {
  description = "The CIDR block for the private subnet"
  type        = string
  default     = "10.0.1.0/28"
}
variable "aws_account_id" {
  type    = string
  default = "REPLACE_WITH_YOUR_AWS_ACCOUNT_ID"
}

variable "region" {
  type    = string
  default = "us-east-1"
}
