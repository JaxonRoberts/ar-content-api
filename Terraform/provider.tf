terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "=2.46.0"
    }
  }
  backend "azurerm" {
    access_key           = "UbybiWOuzTwS0WBJox1KQ0HcSF9nKNygqLTBxYWcHvNA30xTtEkFtteDqfn4DLik+nubHTGk5OJNCGRasRetrg=="
    container_name       = "terraform"
    key                  = "terraform.tfstate"
    storage_account_name = "terraform11148"
 	}
}

provider "azurerm" {
  features {}
  subscription_id = var.SUBS_FUSIONMETRIC_ID
}
