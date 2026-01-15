// COMMON VARIABLES
variable "rsg_name" {
    type = string
    description = "(Required) The name of the resource group in which the resource is created. Changing this forces a new resource to be created."
}

variable "location" {
    type = string
    description = "(Required) Specifies the supported Azure location where the resource exists. Changing this forces a new product to be created."
}

variable "subscriptionid" {
  type        = string
  description = "(Required) Id of Azure Subscription."
}

// PRODUCT
variable "adf_name" {
  type        = string
  description = "(Required) The name of the resource in which to create."
}

// ASSIGNED IDENTITY
variable "uai_name" {
  type        = string
  description = "(Required) Specifies the name of this User Assigned Identity. Changing this forces a new User Assigned Identity to be created."
}

variable "template_adanalytics_name" {
  type        = string
  description = "(Required) Name of the ADanalyics template"
}

variable "identity_list" {
  type        = list(string)
  description = "(Optional) List of identities to assign to data factory."
  default     = []
}

variable "enable_github" {
  type        = bool
  description = "(Optional) Should Azure Data Factory enable github configuration ? Possible values: true, false."
  default     = false
}

variable "account_name" {
  type        = string
  description = "(Optional) Specifies the GitHub account name. Set when enable_github is true."
  default     = null
}

variable "branch_name" {
  type        = string
  description = "(Optional) Specifies the branch of the repository to get code from. Set when enable_github is true."
  default     = "main"
}

variable "git_url" {
  type        = string
  description = "(Optional) Specifies the GitHub Enterprise host name. For example: https://github.mydomain.com. Use https://github.com for open source repositories. Set when enable_github is true."
  default     = null
}

variable "repository_name" {
  type        = string
  description = "(Optional) Specifies the name of the git repository. Set when enable_github is true."
  default     = null
}

variable "root_folder" {
  type        = string
  description = "(Optional) Specifies the root folder within the repository. Set to / for the top level. Set when enable_github is true."
  default     = "/"
}

variable "adf_vnet_enabled" {
  type        = bool
  description = "(Optional) Specifies whether the managed virtual network is enabled or not."
  default     = false
}

variable "adf_public_network_access_enabled" {
  type        = bool
  description = "(Optional) Enable Public Network Access. Possible values: true, false"
  default     = true
}

// KEY VAULT 
 variable "akv_rsg_name"{
    type = string
    description = "(Optional) Specifies the name of the Resource Group where the key vault is located. If key_exist or key_custom_enabled are true or the first chart of CIA Tag is `A` and it deploys in preproduction or production env, this variable must be set."
    default = ""
}

variable "akv_name"{
    type = string
    description = "(Optional) Specifies the name of the common key vault. If key_exist or key_custom_enabled are true or the first chart of CIA Tag is `A` and it deploys in preproduction or production env, this variable must be set."
    default = ""
}

variable "key_name"{
    type = string
    description = "(Optional) The key name used for encryption. If key_exist or key_custom_enabled are true or the first chart of CIA Tag is `A` and it deploys in preproduction or production env, this variable must be set."
    default = ""
}

variable "key_exist" {
    type = bool
    description = "(Optional) Flag to determined if the encryption key exists or not."
    default = false
}

variable "key_custom_enabled" {
    type = bool
    description = "(Optional) Flag to determine if the encryption is customized or will be performed by Azure. In case the variable key_exist is true or the first chart of CIA Tag is `A` and it deploys in preproduction or production env, the value will be ignored and asume for it a true value."
    default = true
}

// MONITOR DIAGNOSTICS SETTINGS
variable "lwk_rsg_name"{
    type = string
    description = "(Required) The name of the resource group where the lwk is located."
}

variable "lwk_name"{
    type = string
    description = "(Required) Specifies the name of a Log Analytics Workspace where Diagnostics Data should be sent."
}

variable "analytics_diagnostic_monitor_name"{
    type = string
    description = "(Required) The name of the diagnostic monitor."
}

variable "analytics_diagnostic_monitor_enabled"{
    type = bool
    description = "(Optional) Flag to set if the diagnostic monitor is used or not. If the resource deploys in production env, the value will be ignored and asume for it a true value."
    default = true
}

############################################
# Naming / tags
############################################
variable "entity" {
  description = "(Required) Entity/product tag (also used in name)."
  type        = string
}

variable "environment" {
  description = "(Required) Environment tag (e.g. dev/qa/prod)."
  type        = string
}

variable "app_name" {
  description = "(Required) Application tag (also used in name)."
  type        = string
}

variable "sequence_number" {
  description = "(Required) Sequence number used in name (e.g. 001)."
  type        = string
}

variable "cost_center" {
  description = "(Optional) Cost center tag."
  type        = string
  default     = null
}

variable "tracking_code" {
  description = "(Optional) Tracking code tag."
  type        = string
  default     = null
}

variable "inherit" {
  description = "(Optional) Present for compatibility with existing tfvars. Not used by this module."
  type        = bool
  default     = true
}

variable "custom_tags" {
  description = "(Optional) Custom tags to merge into the Storage Account."
  type        = map(string)
  default     = {}
}

variable "optional_tags" {
  description = "(Optional) Extra tags to merge into the Storage Account."
  type        = map(string)
  default     = {}
}
