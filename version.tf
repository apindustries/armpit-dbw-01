terraform {

  required_version = ">=1.9.8"
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = ">=3.95"
    }
    azuredevops = {
      source  = "microsoft/azuredevops"
      version = ">=0.0.1"
    }
    azapi = {
      source = "Azure/azapi"
    }
    azuread = {
      source  = "hashicorp/azuread"
      version = ">=2.53.1"
    }
    random = {
      source  = "hashicorp/random"
      version = ">=3.5.0"
    }
    null = {
      source  = "hashicorp/null"
      version = ">=3.2.0"
    }
    time = {
      source  = "hashicorp/time"
      version = ">=0.7.2"
    }
  }
}

provider "azurerm" {
  use_oidc = true
  features {}  
}