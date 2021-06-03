data "azurerm_client_config" "current" {}

# =====================================================================
# ARProject Azure Key Vault
# =====================================================================
resource "azurerm_key_vault" "dev" {
  enabled_for_disk_encryption = true
  location                    = var.location
  name                        = "keyvaultarprojectdev"
  purge_protection_enabled    = false
  resource_group_name         = var.resource_group
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

/*
resource "azurerm_key_vault_secret" "sql_userid" {
  name         = "sql-server-userid"
  value        = var.sql_server_userid
  key_vault_id = azurerm_key_vault.sandbox.id
  depends_on   = [azurerm_key_vault_access_policy.sandbox]
}

resource "azurerm_key_vault_secret" "sql_passwd" {
  name         = "sql-server-passwd"
  value        = var.sql_server_passwd
  key_vault_id = azurerm_key_vault.sandbox.id
  depends_on   = [azurerm_key_vault_access_policy.sandbox]
}

resource "azurerm_key_vault_secret" "windows_userid" {
  name         = "windows-userid"
  value        = var.windows_userid
  key_vault_id = azurerm_key_vault.sandbox.id
  depends_on   = [azurerm_key_vault_access_policy.sandbox]
}

resource "azurerm_key_vault_secret" "windows_passwd" {
  name         = "windows-passwd"
  value        = var.windows_passwd
  key_vault_id = azurerm_key_vault.sandbox.id
  depends_on   = [azurerm_key_vault_access_policy.sandbox]
}

resource "azurerm_key_vault_secret" "container_userid" {
  name         = "container-userid"
  value        = var.container_userid
  key_vault_id = azurerm_key_vault.sandbox.id
  depends_on   = [azurerm_key_vault_access_policy.sandbox]
}

resource "azurerm_key_vault_secret" "container_passwd" {
  name         = "container-passwd"
  value        = var.container_passwd
  key_vault_id = azurerm_key_vault.sandbox.id
  depends_on   = [azurerm_key_vault_access_policy.sandbox]
}

# =====================================================================
# ARProject Azure SQL Server
# =====================================================================
resource "azurerm_sql_server" "sandbox" {
  administrator_login          = azurerm_key_vault_secret.sql_userid.value
  administrator_login_password = azurerm_key_vault_secret.sql_passwd.value
  name                         = "sql-dev-modpims-sandbox"
  location                     = var.location
  resource_group_name          = azurerm_resource_group.sandbox.name
  version                      = "12.0"
  tags = var.tags
}

resource "azurerm_sql_firewall_rule" "sandbox-firewall-rule-0" {
  name                = "Azure_Services"
  resource_group_name = azurerm_resource_group.sandbox.name
  server_name         = azurerm_sql_server.sandbox.name
  start_ip_address    = "0.0.0.0"
  end_ip_address      = "0.0.0.0"
}

resource "azurerm_sql_firewall_rule" "sandbox-firewall-rule-1" {
  name                = "Chris_IPAddress_1"
  resource_group_name = azurerm_resource_group.sandbox.name
  server_name         = azurerm_sql_server.sandbox.name
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
  resource_group_name = azurerm_resource_group.sandbox.name
  server_name         = azurerm_sql_server.sandbox.name
  tags = var.tags
}

# =====================================================================
# ARProject Azure Virtual Network
# =====================================================================
resource "azurerm_virtual_network" "sandbox" {
  address_space       = ["10.202.0.0/16"]
  location            = var.location
  name                = "vnet-dev-modpims-sandbox"
  resource_group_name = azurerm_resource_group.sandbox.name
  tags = var.tags
}

# =====================================================================
# ARProject Azure Virtual Subnet (Virtual Machines)
# =====================================================================
resource "azurerm_subnet" "sandbox" {
  address_prefixes     = ["10.202.1.0/24"]
  name                 = "subnet-dev-modpims-sandbox"
  resource_group_name  = azurerm_resource_group.sandbox.name
  virtual_network_name = azurerm_virtual_network.sandbox.name
}

# =====================================================================
# ARProject Azure Virtual Subnet (Containers)
# =====================================================================
resource "azurerm_subnet" "sandbox_containers" {
  address_prefixes     = ["10.202.2.0/24"]
  name                 = "subnet-containers-dev-modpims-sandbox"
  resource_group_name  = azurerm_resource_group.sandbox.name
  virtual_network_name = azurerm_virtual_network.sandbox.name
}

# =====================================================================
# ARProject Azure Container Network Profile
# =====================================================================
resource "azurerm_network_profile" "sandbox" {
  name                = "netprofile-dev-modpims-sandbox"
  location            = var.location
  resource_group_name = azurerm_resource_group.sandbox.name

  container_network_interface {
    name = "containernic"

    ip_configuration {
      name      = "internal"
      subnet_id = azurerm_subnet.sandbox_containers.id
    }
  }

  tags = var.tags
}

# =====================================================================
# ARProject Azure Container Registry
# =====================================================================
resource "azurerm_container_registry" "sandbox" {
  admin_enabled       = true
  location            = var.location
  name                = "containerregistrydevmodpimssandbox"
  resource_group_name = azurerm_resource_group.sandbox.name
  sku                 = "Basic"

  tags = var.tags
}

# =====================================================================
# ARProject Azure Container Group / Container Instance (ACI)
# =====================================================================
resource "azurerm_container_group" "sandbox" {
  dns_name_label      = "aci-dev-modpims-sandbox"

  image_registry_credential {
      password = azurerm_key_vault_secret.container_passwd.value
      server   = "containerregistrydevmodpimssandbox.azurecr.io"
      username = azurerm_key_vault_secret.container_userid.value
  }

  ip_address_type     = "public"
  location            = var.location
  name                = "acg-dev-modpims-sandbox"
  #network_profile_id  = azurerm_network_profile.sandbox.id
  os_type             = "Linux"
  resource_group_name = azurerm_resource_group.sandbox.name

  container {
    name   = "api-dev-modpims-sandbox"
    image  = "containerregistrydevmodpimssandbox.azurecr.io/sandbox:latest"
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