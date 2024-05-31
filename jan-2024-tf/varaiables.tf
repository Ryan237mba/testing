variable "Team" {
  description = "Team name"
  default     = "Alpha"
  type        = string
}

variable "Environment" {
  default     = "Dev"
  description = "Env name"
  type        = string
}

variable "vpc_cidr" {
  description = "vpc cidr"
  default     = "10.0.0.0/16"
  type        = string
}

variable "vpc_tenancy" {
  description = "vpc tenancy"
  default     = "default"
  type        = string
}


variable "sg_ports" {
  description = "sg ports"
  default     = ["3000", "80", "443", "22"]
  type        = list(string)
}
