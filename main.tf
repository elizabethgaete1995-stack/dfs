# Define variables for local scope
locals {
  # Activa CMK solo si realmente lo estás usando (si no, queda apagado)
  key_cmk = try(var.key_exist, false) || try(var.key_custom_enabled, false)

  # Activa Log Analytics si lo pides o si el naming del RG lo gatilla (si no existe var, queda false)
  lwk_enabled = (
    (try(substr(var.rsg_name, 3, 1), "") == "p") ||
    (try(var.analytics_diagnostic_monitor_enabled, false) == true)
  )

  # Tags base (mínimos) — ajusta llaves si tu estándar corporativo usa otras
  private_tags = {
    entity        = try(var.entity, null)
    environment   = try(var.environment, try(var.enviroment, null))
    app_name      = try(var.app_name, null)
    cost_center   = try(var.cost_center, null)
    tracking_code = try(var.tracking_code, null)
    hidden-deploy = "curated"
  }

  # Tags finales (si hay inherit, lo calculas donde corresponda; esto evita el "local.tags" faltante)
  tags = merge(local.private_tags, try(var.custom_tags, {}), try(var.optional_tags, {}))
}


/* locals {
  private_tags = {
    entity        = var.entity
    environment   = var.environment
    app_name      = var.app_name
    cost_center   = var.cost_center
    tracking_code = var.tracking_code
    hidden-deploy = "curated"
  }
}

  parameters_adanalytics = {
    name              = { value = "${var.adf_name}" }
    location          = { value = "${var.location}" }
    resourcegroupName = { value = "${var.rsg_name}" }
    subscriptionId    = { value = "${var.subscriptionid}" }
    workspaceName     = { value = "${var.lwk_name}" }
    solutionTypes     = { value = ["AzureDataFactoryAnalytics"] } # Necessary to solve replan/reapply issue
    tagsByResource    = { value = "${merge(local.tags, var.custom_tags)}" }
  }
}
*/
# Get info about curent session
data "azurerm_client_config" "current" {
}

# Get and set a resource group for deploy. 
data "azurerm_resource_group" "rsg_principal" {
  name = var.rsg_name
}

# Get and set a key vault. 
data "azurerm_key_vault" "akv_principal" {
  count      = local.key_cmk ? 1 : 0
  depends_on = [data.azurerm_resource_group.rsg_principal]

  name                = var.akv_name
  resource_group_name = data.azurerm_resource_group.rsg_principal.name
}

# Get and set a monitor diagnostic settings
data "azurerm_log_analytics_workspace" "lwk_principal" {
  count = local.lwk_enabled == true ? 1 : 0

  name                = var.lwk_name
  resource_group_name = var.lwk_rsg_name
}

# Create and configure a Key
resource "azurerm_key_vault_key" "key_generate" {
  count      = !var.key_exist && local.key_cmk ? 1 : 0
  depends_on = [data.azurerm_key_vault.akv_principal]

  name         = var.key_name
  key_vault_id = data.azurerm_key_vault.akv_principal[0].id
  key_type     = "RSA"
  key_size     = 2048

  #tags = var.inherit ? merge(merge(data.azurerm_resource_group.rsg_principal.tags, var.custom_tags), local.private_tags) : local.tags

  key_opts = [
    "decrypt",
    "encrypt",
    "sign",
    "unwrapKey",
    "verify",
    "wrapKey",
  ]
}

data "azurerm_key_vault_key" "key_principal" {
  count      = local.key_cmk ? 1 : 0
  depends_on = [azurerm_key_vault_key.key_generate]

  name         = var.key_name
  key_vault_id = data.azurerm_key_vault.akv_principal[0].id
}

# Create and configure a User Manage Identity
resource "azurerm_user_assigned_identity" "uai" {
  count = local.key_cmk ? 1 : 0

  resource_group_name = data.azurerm_resource_group.rsg_principal.name
  location            = data.azurerm_resource_group.rsg_principal.location
  name                = var.uai_name
  tags                = var.inherit ? merge(merge(data.azurerm_resource_group.rsg_principal.tags, var.custom_tags), local.private_tags) : local.tags
}

resource "azurerm_key_vault_access_policy" "akv_access_policy" {
  count      = local.key_cmk ? 1 : 0
  depends_on = [data.azurerm_key_vault.akv_principal, azurerm_user_assigned_identity.uai]

  key_vault_id = data.azurerm_key_vault.akv_principal[0].id
  tenant_id    = data.azurerm_client_config.current.tenant_id
  object_id    = azurerm_user_assigned_identity.uai[0].principal_id

  key_permissions = [
    "UnwrapKey", "WrapKey", "Get",
  ]

  secret_permissions = [
    "Get",
  ]
}

resource "azurerm_data_factory" "adf" {
  name                             = var.adf_name
  location                         = var.location
  resource_group_name              = data.azurerm_resource_group.rsg_principal.name
  managed_virtual_network_enabled  = var.adf_vnet_enabled
  public_network_enabled           = var.adf_public_network_access_enabled
  customer_managed_key_id          = local.key_cmk == true ? data.azurerm_key_vault_key.key_principal[0].id : null
  customer_managed_key_identity_id = local.key_cmk == true ? azurerm_user_assigned_identity.uai[0].id : null

  dynamic "github_configuration" {
    for_each = var.enable_github == false ? [] : [1]
    content {
      account_name    = var.account_name
      branch_name     = var.branch_name
      git_url         = var.git_url
      repository_name = var.repository_name
      root_folder     = var.root_folder
    }
  }

  identity {
    type         = local.key_cmk == true ? "UserAssigned" : "SystemAssigned"
    identity_ids = local.key_cmk == true ? distinct(compact(concat(var.identity_list, formatlist(azurerm_user_assigned_identity.uai[0].id)))) : null
  }
  #tags = var.inherit ? merge(merge(data.azurerm_resource_group.rsg_principal.tags, var.custom_tags), local.private_tags) : local.tags
}

resource "azurerm_data_factory_linked_service_key_vault" "linked" {
  count      = local.key_cmk ? 1 : 0
  depends_on = [azurerm_data_factory.adf]

  name            = "AzureKeyVaultLinkedService"
  data_factory_id = azurerm_data_factory.adf.id
  key_vault_id    = data.azurerm_key_vault.akv_principal[0].id
}


# ADF analytics
resource "azurerm_resource_group_template_deployment" "ADAnalytics" {
  depends_on = [azurerm_data_factory.adf, azurerm_data_factory_linked_service_key_vault.linked]

  name                = var.template_adanalytics_name
  resource_group_name = var.rsg_name
  template_content    = file("${path.module}/scripts/arm/analytics.json")

  parameters_content = jsonencode(local.parameters_adanalytics)
  deployment_mode    = "Incremental"

}


# Diagnostic monitor
resource "azurerm_monitor_diagnostic_setting" "mdsettings" {
  count      = local.lwk_enabled == true ? 1 : 0
  depends_on = [azurerm_data_factory.adf, azurerm_resource_group_template_deployment.ADAnalytics]

  name                           = var.analytics_diagnostic_monitor_name
  target_resource_id             = azurerm_data_factory.adf.id
  log_analytics_workspace_id     = data.azurerm_log_analytics_workspace.lwk_principal[0].id
  log_analytics_destination_type = "AzureDiagnostics"

  enabled_log {
    category = "ActivityRuns"
  }

  enabled_log {
    category = "PipelineRuns"
  }

  enabled_log {
    category = "TriggerRuns"
  }

  enabled_log {
    category = "SandboxPipelineRuns"
  }

  enabled_log {
    category = "SSISPackageEventMessages"
  }

  enabled_log {
    category = "SSISPackageExecutableStatistics"
  }

  enabled_log {
    category = "SSISPackageEventMessageContext"
  }

  enabled_log {
    category = "SSISPackageExecutionComponentPhases"
  }

  enabled_log {
    category = "SSISPackageExecutionDataStatistics"
  }

  enabled_log {
    category = "SSISIntegrationRuntimeLogs"
  }

  enabled_log {
    category = "SandboxActivityRuns"
  }

  enabled_log {
    category = "AirflowDagProcessingLogs"
  }

  enabled_log {
    category = "AirflowTaskLogs"
  }

  enabled_log {
    category = "AirflowWebLogs"
  }

  enabled_log {
    category = "AirflowWorkerLogs"
  }

  enabled_log {
    category = "AirflowSchedulerLogs"
  }
  
  metric {
    category = "AllMetrics"
  }
}
