// COMMON VARIABLES
rsg_name = "rg-poc-test-001"
location = "chilecentral"
subscriptionid = "ef0a94be-5750-4ef8-944b-1bbc0cdda800"

// PRODUCT
adf_name                    = "pocchladf001"
enable_github               = false                 # enable_github = true
account_name                = "aodf"            # account_name = "myaccount"
branch_name                 = "main"               # branch_name = "master"
git_url                     = "https://github.com" # git_url = "https://github.alm.europe.cloudcenter.corp/sgt-cloudplatform/iac.az.modules.appgateway-v2-sm.git"
repository_name             = "prueba"             # repository_name = "aci"
root_folder                 = "/"                  # root_folder = "/"
template_adanalytics_name   = "pocchladf001-adm"

// VIRTUAL NETWORK - SUBNET
adf_vnet_enabled                  = false
adf_public_network_access_enabled = true
key_custom_enabled = false


// KEY VAULT
akv_rsg_name = "rg-poc-test-001"
akv_name     = "akvchilecentralakvdev001"
key_name     = "mykey0302false"
uai_name = "pocchladf001-uai"

// MONITOR DIAGNOSTICS SETTINGS
lwk_rsg_name                         = "rg-poc-test-001"
lwk_name                             = "slwkchilecentrallwkdev001"
analytics_diagnostic_monitor_name    = "pocchladf001-dgm"
analytics_diagnostic_monitor_enabled = true


// TAGGING
cost_center                          = "CC-POCCHL"
location                             = "chilecentral"
entity                               = "dls"
environment                          = "dev"
app_name                             = "poc"
sequence_number                      = "001"
# Custom tags
custom_tags = { "1" = "1", "2" = "2" }
