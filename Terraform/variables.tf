variable "SUBS_FUSIONMETRIC_ID" {
  default = "5619d596-a956-4293-ade9-2f4f0ee340de"
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
    "CreatedBy"  = "chris.palmer"
    "Environment" = "dev"
    "Location"    = "South Central US"
  }
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
