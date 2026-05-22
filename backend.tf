terraform {
  backend "azurerm" {
    resource_group_name  = "tfstate-rg"
    storage_account_name = "sasiniterraformstate"
    container_name       = "tfstate"
    key                  = "voting-app.terraform.tfstate"
  }
}
