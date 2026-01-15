# **Azure Data Factory**

[![Build Status](https://dev.azure.com/SGT-CCoE/CuratedModules/_apis/build/status/itdmodstage01)](https://dev.azure.com/SGT-CCoE/CuratedModules/_releaseProgress?_a=release-environment-logs&releaseId=4603&environmentId=18507)

## Overview

> **IMPORTANT**: If you want to run this module it is an important requirement to specify the azure provider version, you must set the azure provider version and the terraform version in version.tf file.

| Terraform version | Azure version |
| :-----: | :-----: |
| 1.7.1 | 3.90.0 |

> **IMPORTANT 2**: this module have be designed in a way that if enable encryption parameter is activated then only ADF with basic features will be generated and no Identity will be created. Only System Assigned Identity is allowed for this module. Please refer to the following link : https://docs.microsoft.com/en-us/azure/templates/microsoft.datafactory/factories?tabs=json#FactoryIdentity

> **IMPORTANT 3**: until the release of a new version Azure will ignore the addition of a Key Vault Access Policy, but will create an user managed identity. Once the azure provider version is updated, it is needed to make changes to the access policy (source code main.tf), provide access to the customer managed key and allow the encryption of the Data Factory.

### Acronym

Acronym for the product is **adf** .

## Description

Cloud-based data integration service that allows you to create data-driven workflows in the cloud for orchestrating and automating data movement and data transformation. Using Azure Data Factory, you can create and schedule data-driven workflows (called pipelines) that can ingest data from disparate data stores.

Azure Data Factory is composed of four key components. These components work together to provide the platform on which you can compose data-driven workflows with steps to move and transform data.

|Configuration|Description|
|:--:|:--:|
|Pipeline|A pipeline is a logical grouping of activities that performs a unit of work. Together, the activities in a pipeline perform a task.|
|Activity|Activities represent a processing step in a pipeline. Data Factory supports three types of activities: data movement activities, data transformation activities, and control activities.|
|Datasets|Datasets represent data structures within the data stores, which simply point to or reference the data you want to use in your activities as inputs or outputs.|
|Linked services|Linked services are much like connection strings, which define the connection information that's needed for Data Factory to connect to external resources.|
|Triggers|Triggers represent the unit of processing that determines when a pipeline execution needs to be kicked off.|
|Pipeline runs|A pipeline run is an instance of the pipeline execution. Pipeline runs are typically instantiated by passing the arguments to the parameters that are defined in pipelines.The arguments can be passed manually or within the trigger definition.|
|Parameters|Parameters are key-value pairs of read-only configuration. Parameters are defined in the pipeline.|
|Control flow |Control flow is an orchestration of pipeline activities that includes chaining activities in a sequence, branching, defining parameters at the pipeline level, and passing arguments while invoking the pipeline on-demand or from a trigger.|

## Public Documentation

[Azure Data Factory Overview](https://docs.microsoft.com/en-us/azure/data-factory/introduction)<br>
[Azure Data Factory Terraform](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/data_factory)

## Dependencies

The following resources must exist before the deployment can take place:

Resources given by the Cloud Competence Center that need to be in place:

- Azure Subscription
- Resource Group
- Log Analytics Workspace (formerly OMS) for health logs and metrics
- Key Vault to create a Key Vault Link Service in Azure Data Factory.
- A deployment Service Principal with owner permissions on the resource group

## Architecture example:

![Architecture diagram](Documentation/architecture_diagram.png "Architecture diagram")


## Networking

### Network topology

![Network diagram](Documentation/network_diagram.png "Network diagram")

### Egress connections


### Exposed product endpoints

The following endpoints can be used to consume or manage the Certified Product:

#### Management endpoints (Control Plane)

These endpoints will allow to make changes in the configuration of the Certified Service, change permissions or make application deployments.
|EndPoint|IP/URL  |Protocol|Port|Authorization|
|:--:|:--:|:--:|:--:|:--:|
|Azure Resource Management REST API|<https://management.azure.com/>|HTTPS|443|Azure Active Directory|
|Command Channel| n/a |HTTPS|443|Authentication and Authorization via Azure AD RBAC model|
|Web Portal|<https://adf.azure.com>|HTTPS|443|Management web portal specific to Data Factory, Authentication and Authorization via Azure AD RBAC model. Additional security using Conditional Access might be applied by Protect to control access to Data Factory portal together to Azure Portal. More information: <https://docs.microsoft.com/en-us/azure/role-based-access-control/conditional-access-azure-management>|

#### Consumption endpoints (Data Plane)

These endpoints will allow you to consume the Certified Service from an application perspective.
|EndPoint|IP/URL  |Protocol|Port|Authorization|
|:--:|:--:|:--:|:--:|:--:|
|Data Channel|n/a|HTTPS|443|Authentication and Authorization by source provider|

### Configuration

| Tf Name | Default Value | Type |Mandatory | Description |
|:--:|:--:|:--:|:--:|:--:|
| rsg_name| n/a| `string` | YES| The name of the resource group in which the resource is created. Changing this forces a new resource to be created.|
| subscriptionid | n/a | string| Yes| Id of Azure Subscription.|
| location| n/a| `string` | YES| Specifies the supported Azure location where the resource exists. Changing this forces a new product to be created.|
| adf_name| n/a| `string` | YES | The name of the resource in which to create|
| template_adanalytics_name| n/a| `string`| YES| Name of the ADanalyics template.|
| identity_list| []| `list(string)`| NO| List of identities to assign to data factory.|
| enable_github| false | `bool`| NO| Should Azure Data Factory enable github configuration ? Possible values: true, false.|
| account_name| null | `string`| NO| Specifies the GitHub account name.|
| branch_name| "main"| `string`| NO| Specifies the branch of the repository to get code from.|
| git_url| null| `string` | NO| Specifies the GitHub Enterprise host name. For example: https://github.mydomain.com. Use https://github.com for open source repositories.|
| repository_name| null | `string`| NO| Specifies the name of the git repository.Set when enable_github is true.|
| root_folder| "/"| `string`| NO| Specifies the root folder within the repository. Set to / for the top level. Set when enable_github is true.|
| adf_vnet_enabled | false | `bool`| NO| Specifies whether the managed virtual network is enabled or not.|
| adf_public_network_access_enabled| true| `bool`| NO| Enable Public Network Access. Possible values: true, false.|
| akv_rsg_name| n/a| `string` | NO| Specifies the name of the Resource Group where the key vault is located. If key_exist or key_custom_enabled are true or the first chart of CIA Tag is `A` and it deploys in preproduction or production env, this variable must be set.|
| akv_name| n/a| `string` | NO| Specifies the name of the Key Vault.|
| key_name| n/a| `string` | NO| Specifies the name of the Key.|
| key_exist| false | `bool` | NO | Flag to determined if the encryption key exists or not.|
| key_custom_enabled| true | `bool` | NO | Flag to determine if the encryption is customized or will be performed by Azure. In case the variable key_exist is true or the first chart of CIA Tag is `A` and it deploys in preproduction or production env, the value will be ignored and asume for it a true value.|
| uai_name | n/a | `string` | YES | Specifies the name of this User Assigned Identity. Changing this forces a new User Assigned Identity to be created. |
| lwk_rsg_name| n/a | `string` | YES| The name of the resource group where the lwk is located.|
| lwk_name| n/a | `string` | YES| Specifies the name of a Log Analytics Workspace where Diagnostics Data should be sent.|
| analytics_diagnostic_monitor_name| n/a| `string` | YES| The name of the diagnostic monitor.|
| analytics_diagnostic_monitor_enabled| true | `bool` | YES| Flag to set if the diagnostic monitor is used or not. If the resource deploys in production env, the value will be ignored and asume for it a true value.|
| inherit | true | `bool` | NO | Inherits resource group tags. Values can be false or true (by default).|
| product | n/a | `string` | YES | The product tag will indicate the product to which the associated resource belongs to. In case shared_costs is Yes, product variable can be empty.|
| cost_center | n/a | `string` | YES | This tag will report the cost center of the resource. In case shared_costs is Yes, cost_center variable can be empty.|
| shared_costs | "No" | `string` | NO | Helps to identify costs which cannot be allocated to a unique cost center, therefore facilitates to detect resources which require subsequent cost allocation and cost sharing between different payers. |
| apm_functional | n/a | `string` | YES | Allows to identify to which functional application the resource belong, and its value must match with existing functional application code in Entity application portfolio management (APM) systems. In case shared_costs is Yes, apm_functional variable can be empty.|
| cia | n/a | `string` | YES | Confidentiality-Integrity-Availability. Allows a  proper data classification to be attached to the resource. |
| custom_tags | {} | `map(string)` | NO | Custom (additional) tags for compliant.|

<br>

## Outputs
|Output Name| Output value | Description
|:--:|:--:|:--:|
| adf_id | azurerm_data_factory.adf.id|Data Factory ID|

<br>

### Usage
Include the next code into your main.tf file:

```hcl
module "adf" {
  source = "Link module"
  
  // COMMON VARIABLES
  rsg_name                           = var.rsg_name                             #Required
  subscriptionid                     = var.subscriptionid                       #Required
  location                           = var.location                             #Required

  // PRODUCT
  adf_name                           = var.adf_name                             #Required
  template_adanalytics_name          = var.template_adanalytics_name            #Required
  identity_list                      = var.identity_list                        #Optional
  enable_github                      = var.enable_github                        #Optional
  account_name                       = var.account_name                         #Optional
  branch_name                        = var.branch_name                          #Optional
  git_url                            = var.git_url                              #Optional
  repository_name                    = var.repository_name                      #Optional
  root_folder                        = var.root_folder                          #Optional
  adf_vnet_enabled                   = var.adf_vnet_enabled                     #Optional
  adf_public_network_access_enabled  = var.adf_public_network_access_enabled    #Optional

  // KEY VAULT   
  akv_rsg_name                         = var.akv_rsg_name                 # Optional
  akv_name                             = var.akv_name                     # Optional
  key_name                             = var.key_name                     # Optional
  key_exist                            = var.key_exist                    # Optional
  key_custom_enabled                   = var.key_custom_enabled           # Optional
  
  // ASSIGNED IDENTITY
  uai_name                             = var.uai_name                     # Required

  // MONITOR DIAGNOSTICS SETTINGS
  lwk_rsg_name                         = var.lwk_rsg_name                             # Required
  lwk_name                             = var.lwk_name                                 # Required
  analytics_diagnostic_monitor_name    = var.analytics_diagnostic_monitor_name        # Required
  analytics_diagnostic_monitor_enabled = var.analytics_diagnostic_monitor_enabled     # Optional  

   // TAGGING
  inherit                               = var.inherit                     # Optional
  product                               = var.product                     # Required if shared_costs is No.
  cost_center                           = var.cost_center                 # Required if shared_costs is No.
  shared_costs                          = var.shared_costs                # Optional
  apm_functional                        = var.apm_functional              # Optional
  cia                                   = var.cia                         # Required
  custom_tags                           = var.custom_tags                 # Optional
}
```

Include the next code into your outputs.tf file:

```hcl

Output "adf_id" {
    description = "Data Factory ID"
	Value = module.azurerm_data_factory.adf.id
}
```

You can watch more details about [Azure Data Factory configuration parameters](/variables.tf).

# **Security Framework**

This section explains how the different aspects to have into account in order to meet the Security Controls for Cloud for this Certified Service. See SCC v1.0 here: <https://confluence.alm.europe.cloudcenter.corp/x/QBH5AQ>

## Security Briefing

- CMEK: compliant as it does not store any data.
- Network Perimeter - ingress connections: compliant.
- Network Perimeter - egress connections: mitigation is possible. Let your eCISO know if you are using this product.

![Data Factory Security Issues Briefing](Documentation/data-factory-security.png "Data Factory Security Issues Briefing")

For egress connections, which cannot be fully protected according to Cyber requirements, there are some mitigations that can be put in place:

- **Shift-left security**: Workflows running in a Data Factory can be defined by code in a linked Git repository. SSDLC controls in ALM and releasing processes can be implemented (e.g. code review, SAST, quality gates in CI/CD).


## Security Controls based on Security Control for Cloud Framework

### Foundation (**F**) Controls for Rated Workloads
|SF#|What|How it is implemented in the Product|Who|
|:--:|:---:|:---:|:--:|
|SF1|IAM on all accounts|Azure AD RBAC access is enabled in certified product.<br><br>A System-assigned Managed Identity is generated and Azure Key Vault is linked in the certified product.|<ul><li>CCoE</li><li>Entity</li></ul>|
|SF2|MFA on account|This is governed by Azure AD.|<ul><li>CISO</li><li>CCoE</li><li>Entity</li></ul>|
|SF3|Platform Activity Logs & Security Monitoring|Platform logs and security monitoring are provided by Platform.|<ul><li>CISO</li><li>CCoE</li><li>Entity</li></ul>|
|SF4|Malware Protection on IaaS|Certified product does not deploy virtual machines. The machines which host data factory have to be generated apart from this curated module following the security principles for IaaS resources.|<ul><li>CISO</li><li>CCoE</li><li>Entity</li></ul>|
|SF5|Authenticate all connections|A System-assigned Managed Identity is generated and Azure Key Vault is linked in the certified product.<br><br>Workload team must ensure all connections are authenticated. Review the [Connectors documentation](https://docs.microsoft.com/en-us/azure/data-factory/connector-overview) for further details.|<ul><li>CCoE</li><li>Entity</li></ul>|
|SF6|Isolated environments at network level|Workload team can ensure network isolation using Data Factory **self-hosted Integration Runtime** instead of the cloud Integration Runtime. Private Endpoint is selected for connectivity with self-hosted Integration Runtime in certified module.|<ul><li>CISO</li><li>CCoE</li><li>Entity</li></ul>|
|SF7|Security Configuration & Patch Management|Since this is Data Factory resource is a **PaaS** service, product upgrade and patching is done by CSP.<br><br>Certified product does not deploy virtual machines. The machines which host data factory have to be generated apart from this curated module following the security principles for IaaS resources.<br><br>For the artifacts deployed the CCoE team is responsible for upgrading any application framework used by the app to the right patching level.|<ul><li>CCoE</li><li>Entity</li></ul>|
|SF8|Privileged Access Management|**Data Plane**: Access to data plane is not considered Privileged Access.<br>**Control Plane**: Access to control plane is considered Privileged Access and is governed as per the Azure Management Endpoint Privileged Access Management policy.|<ul><li>CISO</li><li>CCoE</li></ul>|
### Application (**P**) Controls for Rated Workloads
|SP#|What|How it is implemented in the Product|Who|
|:--:|:---:|:---:|:--:|
|SP1|Resource tagging for all resources|Product includes all required tags in the deployment template.|<ul><li>CISO</li><li>CCoE</li></ul>|
|SP2|Segregation of Duties|Segregation of Duties must be done by using using RBAC.|<ul><li>CISO</li><li>CCoE</li><li>Entity</li></ul>|
|SP3|Vulnerability Management|Since this is Data Factory resource is a **PaaS** service, product upgrade and patching is done by CSP.<br><br>Certified product does not deploy virtual machines. The machines which host data factory have to be generated apart from this curated module following the security principles for IaaS resources.<br><br>For the artifacts deployed the CCoE team is responsible for upgrading any application framework used by the app to the right patching level.|<ul><li>CISO</li><li>CCoE</li><li>Entity</li></ul>|
|SP4|Service Logs and Security Monitoring|Product is connected to Log Analytics for activity and security monitoring.|<ul><li>CISO</li><li>CCoE</li><li>Entity</li></ul>|
|SP5|Network Security|Workload team can ensure network isolation using Data Factory **self-hosted Integration Runtime** instead of the cloud Integration Runtime. Private Endpoint is selected for connectivity with self-hosted Integration Runtime in certified module.<br><br>Virtual Machines deployed to host the environment must implement network security propertly (NSG, UDR).|<ul><li>CISO</li><li>CCoE</li><li>Entity</li></ul>|
|SP6|Advanced Malware Protection on IaaS|Certified product does not deploy virtual machines. The machines which host data factory have to be generated apart from this curated module following the security policies for IaaS resources.|<ul><li>CISO</li><li>CCoE</li><li>Entity</li></ul>|
|SP7|Cyber incidents management & Digital evidences gathering|Entity must support Cyber Security operations responding to incidents.|<ul><li>CISO</li><li>Entity</li></ul>|
|SP8|Encrypt data in transit over public interconnections|No public endpoint is exposed in certified module.|<ul><li>CCoE</li><li>Entity</li></ul>|
|SP9|Static Application Security Testing|Deployed applications must be integrated into the corporate SSDLC.|<ul><li>Entity</li></ul>|
### Medium (**M**) Controls for Rated Workloads
|SM#|What|How it is implemented in the Product|Who|
|:--:|:---:|:---:|:--:|
|SM1|IAM|Azure AD RBAC access is enabled in certified product.<br><br>A System-assigned Managed Identity is generated and Azure Key Vault is linked in the certified product.|<ul><li>CCoE</li><li>Entity</li></ul>|
|SM2|Encrypt data at rest|Certified product does not deploy virtual machines. The machines which host data factory have to be generated apart from this curated module following the security principles for IaaS resources, including the Disk Encryption on VMs when needed:<br><br>https://docs.microsoft.com/en-us/azure/virtual-machines/windows/disk-encryption-overview<br><br>Azure Data Factory encrypts data at rest, including entity definitions and any data cached while runs are in progress. By default, data is encrypted with a randomly generated Microsoft-managed key that is uniquely assigned to your data factory.|<ul><li>CCoE</li></ul>|
|SM3|Encrypt data in transit over private interconnections|CCoE Team must use cloud data store that suports HTTPS or TLS for data transfers between data movement services in Data Factory.<br><br>TLS version used for Data Factory is 1.2.<br><br>[Workload team can store credentials or secret values in an Azure Key Vault and use them during pipeline execution to pass to your activities.](https://docs.microsoft.com/en-us/azure/data-factory/how-to-use-azure-key-vault-secrets-pipeline-activities)|<ul><li>CCoE</li><li>Entity</li></ul>|
|SM4|Control resource geographical location|The product location is inherited from the resource group.|<ul><li>CISO</li><li>CCoE</li></ul>|
### Advanced (**A**) Controls for Rated Workloads
|SA#|What|How it is implemented in the Product|Who|
|:--:|:---:|:---:|:--:|
|SA1|IAM|Azure AD RBAC access is enabled in certified product.<br><br>A System-assigned Managed Identity is generated and Azure Key Vault is linked in the certified product.|<ul><li>CCoE</li><li>Entity</li></ul>|
|SA2|Encrypt data at rest|Certified product does not deploy virtual machines. The machines which host data factory have to be generated apart from this curated module following the security principles for IaaS resources, incuding the Disk Encryption on VMs when needed:<br><br>https://docs.microsoft.com/en-us/azure/virtual-machines/windows/disk-encryption-overview<br><br>Azure Data Factory encrypts data at rest, including entity definitions and any data cached while runs are in progress. By default, data is encrypted with a randomly generated Microsoft-managed key that is uniquely assigned to your data factory.<br><br><span style="color:red">**TODO:**</span> [CCoE Team must enable Bring Your Own Key (BYOK) with customer-managed keys feature in AzurePortal for Data Factory.](https://docs.microsoft.com/en-us/azure/data-factory/enable-customer-managed-key)|<ul><li>CCoE</li></ul>|
|SA3|Encrypt data in transit over private interconnections|CCoE Team must use cloud data store that suports HTTPS or TLS for data transfers between data movement services in Data Factory.<br><br>TLS version used for Data Factory is 1.2.<br><br>[Workload team can store credentials or secret values in an Azure Key Vault and use them during pipeline execution to pass to your activities.](https://docs.microsoft.com/en-us/azure/data-factory/how-to-use-azure-key-vault-secrets-pipeline-activities)|<ul><li>CCoE</li><li>Entity</li></ul>|
|SA4|Santander managed keys with HSM and BYOK|<span style="color:red">**TODO:**</span> [CCoE Team must enable Bring Your Own Key (BYOK) with customer-managed keys feature in AzurePortal for Data Factory.](https://docs.microsoft.com/en-us/azure/data-factory/enable-customer-managed-key)|<ul><li>CISO</li><li>CCoE</li><li>Entity</li></ul>|
|SA5|Control resource geographical location|The product location is inherited from the resource group.|<ul><li>CISO</li><li>CCoE</li></ul>|
|SA6|Cardholder and auth sensitive data|Entity is responsable to identify workloads and components processing cardholder and auth sensitive data and apply the security measures to comply with the Payment Card Industry Data Security Standard (PCI-DSS).|<ul><li>Entity</li></ul>|
|SA7|Access control to data with MFA|This is governed by Azure AD.|<ul><li>CISO</li><li>CCoE</li><li>Entity</li></ul>|

# **Basic tf files description**
This section explain the structure and elements that represent the artifacts of product.

|Folder|Name|Description
|:--:|:--:|:--:|
|Documentation|network_diagram.png|Network topology diagram|
|Documentation|architecture_diagram.png|Architecture diagram|
|Documentation|data-factory-security.png|Data Factory security diagram|
|Documentation|Data_Factory_Diagrams.png|Data Factory diagrams power point|
|Documentation|examples|terraform.tfvars|
|Root|README.md|Product documentation file.|
|Root|CHANGELOG.md|Contains the changes added to the new versions of the modules.|
|Root|main.tf|Terraform file to use in pipeline to build and release a product.|
|Root|outputs.tf|Terraform file to use in pipeline to check output.|
|Root|variables.tf|Terraform file to use in pipeline to configure product.|

### Target Audience

|Audience |Purpose  |
|:--:|:--:|
| Cloud Center of Excellence | Understand the Design of this Service |
| Cybersecurity Hub | Understand how the Security Framework is implemented in this Service and who is responsible of each control |
| Service Management Hub | Understand how the Service can be managed according to the Service Management Framework |

# **Links to internal documentation**

**Reference documents** :
- [List of Acronyms](https://confluence.alm.europe.cloudcenter.corp/display/OPTIMUM/Naming+Convention+Excel+Simulator)
- [Repo module strategy for terraform](https://github.alm.europe.cloudcenter.corp/pages/ccc-ccoe/platform-automation-doc/repo-modules_blueprints-naming-strategy.html)
- [Product Portfolio](https://github.alm.europe.cloudcenter.corp/pages/sgt-cloudplatform/documentationGlobalHub/eac-az-portfolio.html)
- [Naming Convention for Azure Resources](https://github.alm.europe.cloudcenter.corp/pages/ccc-ccoe/platform-automation-doc/azure-naming-convention-resources.html)

| Template version | 
|:-----:|
| 1.0.7 |
