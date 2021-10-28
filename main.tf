terraform {
  required_version = "~> 1.0.8"

  required_providers {
    azurerm = {
      source = "hashicorp/azurerm"
      version = ">= 2.70.0"
    }
  }
}

# Configure the Microsoft Azure Provider
provider "azurerm" {
  features {}
}


# Create a resource group
resource "azurerm_resource_group" "main" {
  name     = var.resource_group_name
  location = var.location

  tags = {
    project = "microsegmentation-lab"
  }
}


# Creating random string for use in DNS Labels and Storage Account
resource "random_id" "randomId" {
  keepers = {
      # Generate a new ID only when a new resource group is defined
      resource_group = var.resource_group_name
  }
  byte_length = 4
}

