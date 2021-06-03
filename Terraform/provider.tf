terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "=2.46.0"
    }
  }
  backend "azurerm" {
    access_key           = "MPRGtvWen4jcS/3TRxEox3Wk/sCdsY/egI3D5mVuTnKTdOeOeSUdA5eru8o5bsPf3W/v6mYZZfasvfXxCoKhkQ=="
    container_name       = "terraform"
    key                  = "terraform.tfstate"
    storage_account_name = "terraform12042"
 	}
}

provider "azurerm" {
  features {}
  subscription_id = var.SUBS_FUSIONMETRIC_ID
}
