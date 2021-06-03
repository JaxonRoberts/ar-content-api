variable "SUBS_FUSIONMETRIC_ID" {
  default = "eadd4782-2c6d-4464-9102-9c008db02e3f"
}

variable "location" {
  description = "The location/region where the resources is created."
  default     = "South Central US"
}

variable "tags" {
  description = "The default tags for environment resources"
  type = map
  default = {
    "Application" = "ARProject"
    "created_by"  = "chris.palmer"
    "Environment" = "dev"
    "Location"    = "South Central US"
  }
}

variable "resource_group" {
  description = "The Resource group name"
}

variable "sql_server_userid" {
  description = "The SQL Server Admin UserID to create."
}

variable "sql_server_passwd" {
  description = "The SQL Server Admin Password to set."
}

variable "windows_userid" {
  description = "The Windows 10 Admin UserID to create."
}

variable "windows_passwd" {
  description = "The Windows 10 Admin Password to set."
}

variable "container_userid" {
  description = "The Container Registry Admin UserID to set."
}

variable "container_passwd" {
  description = "The Container Registry Password to set."
}
