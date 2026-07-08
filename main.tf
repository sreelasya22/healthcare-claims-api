# ─────────────────────────────────────────────────────────────────────────────
# main.tf — Healthcare Claims API Infrastructure
# Creates: Resource Group → App Service Plan → App Service (Dev + Cert)
# ─────────────────────────────────────────────────────────────────────────────

# Tell Terraform we are using the Azure provider (like an "import" in Java)
terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 3.90"
    }
  }
  required_version = ">= 1.5.0"
}

# Configure the Azure provider
# Terraform reads your Azure credentials from environment variables automatically
provider "azurerm" {
  features {}
}


# ─────────────────────────────────────────────────────────────────────────────
# VARIABLES — change these to match your actual Azure setup
# ─────────────────────────────────────────────────────────────────────────────

variable "resource_group_name" {
  description = "Name of the Azure Resource Group"
  type        = string
  default     = "healthcare-claims-rg"
}

variable "location" {
  description = "Azure region to deploy resources"
  type        = string
  default     = "East US"
}

variable "app_name_dev" {
  description = "App Service name for Dev environment"
  type        = string
  default     = "claims-api-dev"   # <-- change to your actual dev app name
}

variable "app_name_cert" {
  description = "App Service name for Cert environment"
  type        = string
  default     = "claims-api-cert"  # <-- change to your actual cert app name
}


# ─────────────────────────────────────────────────────────────────────────────
# RESOURCE GROUP — a logical container for all your Azure resources
# ─────────────────────────────────────────────────────────────────────────────

resource "azurerm_resource_group" "main" {
  name     = var.resource_group_name
  location = var.location

  tags = {
    Project     = "Healthcare Claims API"
    Environment = "All"
    ManagedBy   = "Terraform"
  }
}


# ─────────────────────────────────────────────────────────────────────────────
# APP SERVICE PLAN — the "server" that hosts both Dev and Cert app services
# Think of it like renting a VM; App Services run on top of it
# ─────────────────────────────────────────────────────────────────────────────

resource "azurerm_service_plan" "main" {
  name                = "healthcare-claims-plan"
  resource_group_name = azurerm_resource_group.main.name
  location            = azurerm_resource_group.main.location

  os_type  = "Linux"   # Your pipeline uses ubuntu-latest agents + Java on Linux
  sku_name = "B1"      # Basic tier — cheapest paid plan, free tier = "F1"

  tags = {
    Project   = "Healthcare Claims API"
    ManagedBy = "Terraform"
  }
}


# ─────────────────────────────────────────────────────────────────────────────
# APP SERVICE — DEV ENVIRONMENT
# ─────────────────────────────────────────────────────────────────────────────

resource "azurerm_linux_web_app" "dev" {
  name                = var.app_name_dev
  resource_group_name = azurerm_resource_group.main.name
  location            = azurerm_resource_group.main.location
  service_plan_id     = azurerm_service_plan.main.id

  site_config {
    # Tell Azure this is a Java 17 app
    application_stack {
      java_version        = "17"
      java_server         = "JAVA"
      java_server_version = "17"
    }

    always_on = false  # Keep false on Basic/Free tier to avoid billing surprises
  }

  app_settings = {
    "SPRING_PROFILES_ACTIVE" = "dev"           # Spring uses this to load application-dev.properties
    "WEBSITES_PORT"          = "8080"          # Match your Spring Boot server port
  }

  tags = {
    Project     = "Healthcare Claims API"
    Environment = "Dev"
    ManagedBy   = "Terraform"
  }
}


# ─────────────────────────────────────────────────────────────────────────────
# APP SERVICE — CERT ENVIRONMENT
# ─────────────────────────────────────────────────────────────────────────────

resource "azurerm_linux_web_app" "cert" {
  name                = var.app_name_cert
  resource_group_name = azurerm_resource_group.main.name
  location            = azurerm_resource_group.main.location
  service_plan_id     = azurerm_service_plan.main.id

  site_config {
    application_stack {
      java_version        = "17"
      java_server         = "JAVA"
      java_server_version = "17"
    }

    always_on = false
  }

  app_settings = {
    "SPRING_PROFILES_ACTIVE" = "cert"          # Spring loads application-cert.properties
    "WEBSITES_PORT"          = "8080"
  }

  tags = {
    Project     = "Healthcare Claims API"
    Environment = "Cert"
    ManagedBy   = "Terraform"
  }
}


# ─────────────────────────────────────────────────────────────────────────────
# OUTPUTS — printed after terraform apply, useful for confirming what was built
# ─────────────────────────────────────────────────────────────────────────────

output "dev_app_url" {
  description = "URL of the Dev App Service"
  value       = "https://${azurerm_linux_web_app.dev.default_hostname}"
}

output "cert_app_url" {
  description = "URL of the Cert App Service"
  value       = "https://${azurerm_linux_web_app.cert.default_hostname}"
}

output "resource_group" {
  description = "Resource Group name"
  value       = azurerm_resource_group.main.name
}
