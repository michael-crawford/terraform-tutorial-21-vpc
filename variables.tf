variable "region" {
  description = "AWS Region"
  type        = string
  default     = "us-east-2"
}

variable "environment" {
  description = "Environment Name"
  type        = string
  default     = "Production"
}

variable "company" {
  description = "Company Name"
  type        = string
  default     = "MJCConsulting"
}

variable "project" {
  description = "Project Name"
  type        = string
  default     = "Tutorial-21"
}

variable "domain" {
  description = "Domain Name"
  type        = string
  default     = "x.mcrawford.mjcconsulting.com"
}

variable "vpc_cidr" {
  description = "VPC: The CIDR block for the VPC"
  type = string
  default = "10.16.0.0/20"

  validation {
    condition = can(cidrnetmask(var.vpc_cidr))
    //condition = can(regex("^(25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\\.(25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\\.(25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\\.(25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)$",var.vpc_cidr))
    error_message = "Invalid CIDR provided."
  }
}

variable "zone_map" {
  description = "Mapping of allowed AWS Availability Zones to offset within VPC CIDR"

  default     = {
    a = 0
    b = 1
    c = 2
    d = 3
  }
}
