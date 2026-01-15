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

// TAGGING
variable "inherit" {
  type = bool
  description = "(Optional) Inherits resource group tags. Values can be false or true (by default)."
  default = true
}

variable "product" {
    type        = string
    description = "(Required) The product tag will indicate the product to which the associated resource belongs to. In case shared_costs is Yes, product variable can be empty."
    default = null
}

variable "cost_center" {
    type        = string
    description = "(Required) This tag will report the cost center of the resource. In case shared_costs is Yes, cost_center variable can be empty."
    default = null
}

variable "shared_costs" {
    type        = string
    description = "(Optional) Helps to identify costs which cannot be allocated to a unique cost center, therefore facilitates to detect resources which require subsequent cost allocation and cost sharing between different payers."
    default     = "No"
    validation {
        condition     = var.shared_costs == "Yes" || var.shared_costs == "No"
        error_message = "Only `Yes`, `No` or empty values are allowed."
    }
}
  
variable "apm_functional" {
    type        = string
    description = "(Optional) Allows to identify to which functional application the resource belong, and its value must match with existing functional application code in Entity application portfolio management (APM) systems. In case shared_costs is Yes, apm_functional variable can be empty."
    default = null
}
    
variable "cia"{
    type = string
    description = "(Required) Allows a proper data classification to be attached to the resource."
    validation {
        condition     = length(var.cia) == 3 && contains(["C", "B", "A"], substr(var.cia, 0, 1)) && contains(["L", "M", "H"], substr(var.cia, 1, 1)) && contains(["L", "M", "C"], substr(var.cia, 2, 1))   
        error_message = "CIA must be a 3 character long and has to comply with the CIA nomenclature (CLL, BLM, AHM...). In sandbox this variable does not apply."
    }
    default = "AHC"
}

variable "custom_tags"{
    type = map(string)
    description = "(Optional) Custom tags for product."
    default = {}
}