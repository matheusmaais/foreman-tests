variable "cluster_name" {
  type = string
  validation {
    condition     = can(regex("^[a-zA-Z][a-zA-Z0-9-]{0,99}$", var.cluster_name))
    error_message = "Cluster name must start with a letter, contain only alphanumerics and hyphens, max 100 chars."
  }
}

variable "subnet_ids" {
  type = list(string)
  validation {
    condition     = length(var.subnet_ids) >= 2
    error_message = "At least 2 subnets required for HA."
  }
}

variable "vpc_id" {
  type = string
  validation {
    condition     = can(regex("^vpc-", var.vpc_id))
    error_message = "Must be a valid VPC ID."
  }
}

variable "node_desired_size" {
  type    = number
  default = 2
}

variable "node_min_size" {
  type    = number
  default = 1
}

variable "node_max_size" {
  type    = number
  default = 4
}

variable "node_disk_size_gb" {
  type    = number
  default = 50
  validation {
    condition     = var.node_disk_size_gb >= 20
    error_message = "Disk size must be at least 20 GB."
  }
}

variable "tags" {
  type    = map(string)
  default = {}
}
