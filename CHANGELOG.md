# **Changelog**

## **[v2.9.0 (2024-05-09)]**
### Changes
- `Tested` with terraform v1.7.1, azure v3.90.0, .
- `Updated` CHANGELOG.md.
- `Updated` README.md.

## **[v2.8.0 (2023-09-07)]**
- `Update` README.md
- `Update` CHANGELOG.md
- `Update` versions terraform to  1.4.6 and Azure 3.60.0.

## **[v2.7.5 (2023-08-28)]**
- `Update` Delete retention policy block.
- `Update` README.md.

## **[v2.7.3 (2023-03-17)]**
- `Fix` issue with the use of existing key.
- `Change` uai_name variable from Optional to Required in variables and Readme.
- `Add` in azurerm_monitor_diagnostic_setting resource several log disabled entries to solve issue in replan/reapply.
  
## **[v2.7.2 (2023-03-15)]**
- `Added` subscriptionid variable.
  
## **[v2.7.1 (2023-02-22)]**
- `Added` Inherit variable.
- `Update` module with template version v1.0.6.

## **[v2.7.0 (2023-02-7)]**

- `Added` analytics_diagnostic_monitor_name.
- `Added` analytics_diagnostic_monitor_enabled.
- `Added` Condition to use CMK and no trust policy when CIA is A.
- `Changed` old local tags in favour of new tags.
- `Changed` tags assign in resources from a merged group to local.tags.
- `Changed` resource_group variable name in favour of rsg_name.
- `Changed` name variable name in favour of acr_name.
- `Changed` name variable lwk_resource_group_name in favour of lwk_rsg_name.
- `Changed` name variable kvt_name in favour of akv_name.
- `Changed` datagenerated data name in favour of key_principal.
- `Changed` generated resource name in favour of key_generate.
- `Changed` kvt resource name in favour of akv_principal.
- `Update` README.md.
- `Update` module with template version v1.0.5.

## **[v2.6.0 (2023-01-20)]**

- `Added` analytics_diagnostic_monitor_name.
- `Added` analytics_diagnostic_monitor_enabled.
- `Changed` old local tags in favour of new tags.
- `Changed` tags assign in resources from a merged group to local.tags.
- `Changed` resource_group variable name in favour of rsg_name.
- `Changed` name variable name in favour of adf_name.
- `Changed` name variable lwk_resource_group_name in favour of lwk_rsg_name.
- `Changed` name variable kvt_name in favour of akv_name.
- `Changed` datagenerated data name in favour of key_principal.
- `Changed` generated resource name in favour of key_generate.
- `Changed` kvt resource name in favour of akv_principal.
- `Update` README.md.
- `Update` module with template version v1.0.4.

## **[v2.5.0]**

### Changes

- Test Terraform v1.3.2
- Update readme
- Update CHANGELOG
- Delete provider and terraform versions in main.tf

## **[v2.4.3]**

### Changes

- Reestructurate code
- Documentation fixed

## **[v2.4.2]**

### Changes

- update template resource call by a new version
- Solve issue replan/reapply with new template resource
- Change doc

## **[v2.4.1]**

### Changes

- Add new parameter by tfstates consolidation
- Change doc
- Change root example tfvars file

## **[v2.4.0]**

### Changes

- Oficial Module terraform-azurerm-module-adf-sm
- Terraform v1.0.9
- Provider Azure v3.0.2

## **[v2.3.2]**

### Changes

- Terraform v1.0.9
- Provider Azure v3.0.2
- Azurerm Data Factory Category Airflow\* is not supported
- Update CHANGELOG.md and links to internal documentation

## **[v2.3.1]**

### Changes

- Terraform v1.0.9
- Provider Azure v3.0.2
- Case sensitive with azure provider 3.0.2
- Update key_permissions and secret_permissions in azurerm_key_vault_access_policy as the values are case sensitive with azure provider 3.0.2
- Update Readme.md
- Change Linked Service (connection) between Key Vault and Azure Data Factory

## **[v2.3.0]**

### Changes

- Last release iac.az.blueprint.data-factory-sm
- Terraform v1.0.7
- Provider Azure v2.83.0
- Version with terraform (github and encryption)

## **[v2.2.6]**

### Changes

- Clean code

## **[v2.2.5]**

### Changes

- Include Custom Tags & Enable Encryption
- Updated readme
- Included Custom (additional) tags for Azure Data Factory (V2)
- Added a new option to "enable" or "disable" encryption. That means: if enabled then it will be created a basic Data Factory without CMK encryption, without managed virtual network and without Integration Runtime, and with Microsoft managed keys; if disabled then it will be created a more complete ADF (with Integration Runtime, with Managed Vnet if enabled, and with SystemAssigned identity (Microsoft managed keys).
- Other minor fixes

## **[v2.2.0]**

### Changes

- Include Brasil changes

## **[v2.1.0]**

### Changes

- Include public network access

## **[v2.0.0]**

### Changes

- Delete integration runtime resource
- Upgrade data factory

## **[v1.1.1]**

### Changes

- Update source module ir_vm

## **[v1.1.0]**

### Changes

- Update readme

## **[v1.0.0]**

### Changes

- First Release
