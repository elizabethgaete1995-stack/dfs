// COMMON VARIABLES
rsg_name       = "sgtd2weursgitdmodcomm001"
location       = "westeurope"
subscriptionid = "ebac6c00-3c2f-4d56-82c0-8057225d44fa"

// PRODUCT
adf_name                  = "sgtd2weu0302aodf"
enable_github             = false                 # enable_github = true
account_name              = "aodf"               # account_name = "myaccount"
branch_name               = "main"               # branch_name = "master"
git_url                   = "https://github.com" # git_url = "https://github.alm.europe.cloudcenter.corp/sgt-cloudplatform/iac.az.modules.appgateway-v2-sm.git"
repository_name           = "prueba"             # repository_name = "aci"
root_folder               = "/"                  # root_folder = "/"
template_adanalytics_name = "sgtd2weutest0302encryptfalse"

// VIRTUAL NETWORK - SUBNET
adf_vnet_enabled                  = true
adf_public_network_access_enabled = false


// KEY VAULT
akv_rsg_name = "sgtd2weursgitdmodcomm001"
akv_name     = "sgtd2weuakvitdmodcomm002"
key_exist    = true
key_name     = "mykey0302false-exist"
uai_name     = "identitysgtd2weu0302encryptfalse"

// MONITOR DIAGNOSTICS SETTINGS
lwk_rsg_name                         = "sgtd2weursgitdmodcomm001"
lwk_name                             = "sgtd2weulwkitdmodcomm002"
analytics_diagnostic_monitor_name    = "sgtd2weutest0302encryptfalse-dgm"
analytics_diagnostic_monitor_enabled = true


// TAGGING
product        = "Product Test"
cost_center    = "CC-ITDMOD"
shared_costs   = "Yes"
apm_functional = "APM Test"
cia            = "CLL"
# Custom tags
custom_tags = { "1" = "1", "2" = "2" }
