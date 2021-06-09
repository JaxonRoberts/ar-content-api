# =====================================================================
# modPims Azure Resource Group
# =====================================================================
resource "azurerm_resource_group" "dev" {
  location        = var.location
  name            = "ARProject-DEV"
  tags            = var.tags
}

data "azurerm_client_config" "current" {}

# =====================================================================
# ARProject Azure Key Vault
# =====================================================================
resource "azurerm_key_vault" "dev" {
  enabled_for_disk_encryption = true
  location                    = var.location
  name                        = "keyvaultarprojectdev"
  purge_protection_enabled    = false
  resource_group_name         = azurerm_resource_group.dev.name
  sku_name                    = "standard"
  soft_delete_retention_days  = 7
  tenant_id                   = data.azurerm_client_config.current.tenant_id
  tags                        = var.tags
}

resource "azurerm_key_vault_access_policy" "dev" {
  key_vault_id = azurerm_key_vault.dev.id
  tenant_id    = data.azurerm_client_config.current.tenant_id
  object_id    = data.azurerm_client_config.current.object_id

  certificate_permissions = []

  key_permissions = [
    "Get",
    "List",
    "Update",
    "Create",
    "Delete",
    "Import"
  ]

  secret_permissions = [
    "Get",
    "List",
    "Set",
    "Delete",
    "Recover"
  ]

  storage_permissions = []
}

resource "azurerm_key_vault_secret" "container_userid" {
  name         = "container-userid"
  value        = var.container_userid
  key_vault_id = azurerm_key_vault.dev.id
  depends_on   = [azurerm_key_vault_access_policy.dev]
}

resource "azurerm_key_vault_secret" "container_passwd" {
  name         = "container-passwd"
  value        = var.container_passwd
  key_vault_id = azurerm_key_vault.dev.id
  depends_on   = [azurerm_key_vault_access_policy.dev]
}

/*
resource "azurerm_key_vault_secret" "sql_userid" {
  name         = "sql-server-userid"
  value        = var.sql_server_userid
  key_vault_id = azurerm_key_vault.dev.id
  depends_on   = [azurerm_key_vault_access_policy.dev]
}

resource "azurerm_key_vault_secret" "sql_passwd" {
  name         = "sql-server-passwd"
  value        = var.sql_server_passwd
  key_vault_id = azurerm_key_vault.dev.id
  depends_on   = [azurerm_key_vault_access_policy.dev]
}

resource "azurerm_key_vault_secret" "windows_userid" {
  name         = "windows-userid"
  value        = var.windows_userid
  key_vault_id = azurerm_key_vault.dev.id
  depends_on   = [azurerm_key_vault_access_policy.dev]
}

resource "azurerm_key_vault_secret" "windows_passwd" {
  name         = "windows-passwd"
  value        = var.windows_passwd
  key_vault_id = azurerm_key_vault.dev.id
  depends_on   = [azurerm_key_vault_access_policy.dev]
}
*/

/*
# =====================================================================
# ARProject Azure SQL Server
# =====================================================================
resource "azurerm_sql_server" "dev" {
  administrator_login          = azurerm_key_vault_secret.sql_userid.value
  administrator_login_password = azurerm_key_vault_secret.sql_passwd.value
  name                         = "sql-dev-modpims-sandbox"
  location                     = var.location
  resource_group_name          = azurerm_resource_group.dev.name
  version                      = "12.0"
  tags = var.tags
}

resource "azurerm_sql_firewall_rule" "sandbox-firewall-rule-0" {
  name                = "Azure_Services"
  resource_group_name = azurerm_resource_group.dev.name
  server_name         = azurerm_sql_server.dev.name
  start_ip_address    = "0.0.0.0"
  end_ip_address      = "0.0.0.0"
}

resource "azurerm_sql_firewall_rule" "sandbox-firewall-rule-1" {
  name                = "Chris_IPAddress_1"
  resource_group_name = azurerm_resource_group.dev.name
  server_name         = azurerm_sql_server.dev.name
  start_ip_address    = "45.17.220.0"
  end_ip_address      = "45.17.220.255"
}

# =====================================================================
# ARProject Azure SQL Database
# =====================================================================
resource "azurerm_sql_database" "sandbox-database" {
  edition             = "Free"
  location            = var.location
  name                = "modpims"
  resource_group_name = azurerm_resource_group.dev.name
  server_name         = azurerm_sql_server.dev.name
  tags = var.tags
}

# =====================================================================
# ARProject Azure Virtual Network
# =====================================================================
resource "azurerm_virtual_network" "dev" {
  address_space       = ["10.202.0.0/16"]
  location            = var.location
  name                = "vnet-dev-modpims-sandbox"
  resource_group_name = azurerm_resource_group.dev.name
  tags = var.tags
}

# =====================================================================
# ARProject Azure Virtual Subnet (Virtual Machines)
# =====================================================================
resource "azurerm_subnet" "dev" {
  address_prefixes     = ["10.202.1.0/24"]
  name                 = "subnet-dev-modpims-sandbox"
  resource_group_name  = azurerm_resource_group.dev.name
  virtual_network_name = azurerm_virtual_network.dev.name
}

# =====================================================================
# ARProject Azure Virtual Subnet (Containers)
# =====================================================================
resource "azurerm_subnet" "sandbox_containers" {
  address_prefixes     = ["10.202.2.0/24"]
  name                 = "subnet-containers-dev-modpims-sandbox"
  resource_group_name  = azurerm_resource_group.dev.name
  virtual_network_name = azurerm_virtual_network.dev.name
}

# =====================================================================
# ARProject Azure Container Network Profile
# =====================================================================
resource "azurerm_network_profile" "dev" {
  name                = "netprofile-dev-modpims-sandbox"
  location            = var.location
  resource_group_name = azurerm_resource_group.dev.name

  container_network_interface {
    name = "containernic"

    ip_configuration {
      name      = "internal"
      subnet_id = azurerm_subnet.dev_containers.id
    }
  }

  tags = var.tags
}
*/

# =====================================================================
# ARProject Azure Container Registry
# =====================================================================
resource "azurerm_container_registry" "dev" {
  admin_enabled       = true
  location            = var.location
  name                = "containerregistryarprojectdev"
  resource_group_name = azurerm_resource_group.dev.name
  sku                 = "Basic"

  tags = var.tags
}

/*
# =====================================================================
# ARProject Azure Container Group / Container Instance (ACI)
# =====================================================================
resource "azurerm_container_group" "dev" {
  dns_name_label      = "aci-arproject-dev"

  image_registry_credential {
      password = azurerm_key_vault_secret.container_passwd.value
      server   = "containerregistryarprojectdev.azurecr.io"
      username = azurerm_key_vault_secret.container_userid.value
  }

  ip_address_type     = "public"
  location            = var.location
  name                = "acg-arproject-dev"
  os_type             = "Linux"
  resource_group_name = azurerm_resource_group.dev.name

  container {
    name   = "api-arproject-dev"
    image  = "containerregistryarprojectdev.azurecr.io/arprojectapi:latest"
    cpu    = "0.5"
    memory = "1.5"

    ports {
      port     = 80
      protocol = "TCP"
    }
  }

  tags = var.tags
}
*/

# =====================================================================
# ARProject Azure App Service Plan (Linux)
# =====================================================================
resource "azurerm_app_service_plan" "dev" {
  kind                = "Linux"
  location            = var.location
  name                = "appplan-arproject-dev"
  reserved            = true
  resource_group_name = azurerm_resource_group.dev.name
  sku {
    size = "B1"
    tier = "Basic"
  }
  tags                = var.tags
}

# =====================================================================
# ARProject Azure App Service (API)
# Deploys from the Shared Container Registry
# =====================================================================
resource "azurerm_app_service" "dev" {
  app_service_plan_id = azurerm_app_service_plan.dev.id
  enabled             = true
  #https_only         = true
  location            = var.location
  name                = "app-arproject-api"
  resource_group_name = azurerm_resource_group.dev.name

  app_settings = {
    "DOCKER_ENABLE_CI"                    = "true",
    "DOCKER_REGISTRY_SERVER_PASSWORD"     = azurerm_key_vault_secret.container_passwd.value,
    "DOCKER_REGISTRY_SERVER_URL"          = "https://containerregistryarprojectdev.azurecr.io",
    "DOCKER_REGISTRY_SERVER_USERNAME"     = azurerm_key_vault_secret.container_userid.value,
    "WEBSITES_ENABLE_APP_SERVICE_STORAGE" = "false"
  }

  site_config {
    always_on                 = false
    app_command_line          = ""
    auto_swap_slot_name       = ""
    default_documents         = ["index.html"]
    dotnet_framework_version  = "v4.0"
    ftps_state                = "AllAllowed"
    health_check_path         = ""
    http2_enabled             = false
    ip_restriction            = []
    linux_fx_version          = "DOCKER|containerregistryarprojectdev.azurecr.io/arprojectapi:latest"
    managed_pipeline_mode     = "Integrated"
    min_tls_version           = "1.2"
    number_of_workers         = 1
	  remote_debugging_enabled  = false
	  remote_debugging_version  = "VS2019"
    use_32_bit_worker_process = true
    websockets_enabled        = false
    windows_fx_version        = ""
  }

  tags = var.tags
}

resource "azurerm_app_service" "ar2" {
  app_service_plan_id = azurerm_app_service_plan.dev.id
  enabled             = true
  #https_only         = true
  location            = var.location
  name                = "ar2"
  resource_group_name = azurerm_resource_group.dev.name

  app_settings = {
    "DOCKER_ENABLE_CI"                    = "true",
    "DOCKER_REGISTRY_SERVER_PASSWORD"     = azurerm_key_vault_secret.container_passwd.value,
    "DOCKER_REGISTRY_SERVER_URL"          = "https://containerregistryarprojectdev.azurecr.io",
    "DOCKER_REGISTRY_SERVER_USERNAME"     = azurerm_key_vault_secret.container_userid.value,
    "WEBSITES_ENABLE_APP_SERVICE_STORAGE" = "false"
  }

  site_config {
    always_on                 = false
    app_command_line          = ""
    auto_swap_slot_name       = ""
    default_documents         = ["index.html"]
    dotnet_framework_version  = "v4.0"
    ftps_state                = "AllAllowed"
    health_check_path         = ""
    http2_enabled             = false
    ip_restriction            = []
    linux_fx_version          = "DOCKER|containerregistryarprojectdev.azurecr.io/arprojectapi:latest"
    managed_pipeline_mode     = "Integrated"
    min_tls_version           = "1.2"
    number_of_workers         = 1
	  remote_debugging_enabled  = false
	  remote_debugging_version  = "VS2019"
    use_32_bit_worker_process = true
    websockets_enabled        = false
    windows_fx_version        = ""
  }

  tags = var.tags
}
