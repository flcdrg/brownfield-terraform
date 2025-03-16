---
layout: codewrap
---

# Storage account

````md magic-move {lines: true}

```hcl {*}
resource "azurerm_storage_account" "res-8" {
  name                            = "stbfdev"
  resource_group_name             = "rg-brownfield-dev-australiaeast"
  location                        = "australiaeast"
  account_replication_type        = "LRS"
  account_tier                    = "Standard"
  allow_nested_items_to_be_public = false
  min_tls_version                 = "TLS1_0"
}
```

```hcl {*}
import {
  id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-brownfield-dev-australiaeast/providers/Microsoft.Storage/storageAccounts/stbfdev"
  to = azurerm_storage_account.res-8
}

resource "azurerm_storage_account" "res-8" {
  name                            = "stbfdev"
  resource_group_name             = "rg-brownfield-dev-australiaeast"
  location                        = "australiaeast"
  account_replication_type        = "LRS"
  account_tier                    = "Standard"
  allow_nested_items_to_be_public = false
  min_tls_version                 = "TLS1_0"
}
```

```hcl {2,8,9}
import {
  id = "/subscriptions/${data.azurerm_client_config.current.subscription_id}/resourceGroups/${data.azurerm_resource_group.group.name}/providers/Microsoft.Storage/storageAccounts/stbfdev"
  to = azurerm_storage_account.res-8
}

resource "azurerm_storage_account" "res-8" {
  name                            = "stbfdev"
  resource_group_name             = data.azurerm_resource_group.group.name
  location                        = data.azurerm_resource_group.group.location
  account_replication_type        = "LRS"
  account_tier                    = "Standard"
  allow_nested_items_to_be_public = false
  min_tls_version                 = "TLS1_0"
}
```

```hcl {2,7}
import {
  id = "/subscriptions/${data.azurerm_client_config.current.subscription_id}/resourceGroups/${data.azurerm_resource_group.group.name}/providers/Microsoft.Storage/storageAccounts/stbf${var.environment}"
  to = azurerm_storage_account.res-8
}

resource "azurerm_storage_account" "res-8" {
  name                            = "stbf${var.environment}"
  resource_group_name             = data.azurerm_resource_group.group.name
  location                        = data.azurerm_resource_group.group.location
  account_replication_type        = "LRS"
  account_tier                    = "Standard"
  allow_nested_items_to_be_public = false
  min_tls_version                 = "TLS1_0"
}
```

```hcl {3,6|*}
import {
  id = "/subscriptions/${data.azurerm_client_config.current.subscription_id}/resourceGroups/${data.azurerm_resource_group.group.name}/providers/Microsoft.Storage/storageAccounts/stbf${var.environment}"
  to = azurerm_storage_account.storage
}

resource "azurerm_storage_account" "storage" {
  name                            = "stbf${var.environment}"
  resource_group_name             = data.azurerm_resource_group.group.name
  location                        = data.azurerm_resource_group.group.location
  account_replication_type        = "LRS"
  account_tier                    = "Standard"
  allow_nested_items_to_be_public = false
  min_tls_version                 = "TLS1_0"
}
```

````

---

# Let's try it out..

---

# Plan output

```text {*}{maxHeight: '80%' }
Terraform will perform the following actions:

  # azurerm_storage_account.storage will be imported
    resource "azurerm_storage_account" "storage" {
        access_tier                        = "Hot"
        account_kind                       = "StorageV2"
        account_replication_type           = "LRS"
        account_tier                       = "Standard"
        allow_nested_items_to_be_public    = false
        allowed_copy_scope                 = null
        cross_tenant_replication_enabled   = false
        default_to_oauth_authentication    = false
        dns_endpoint_type                  = "Standard"
        edge_zone                          = null
        https_traffic_only_enabled         = true
        id                                 = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-brownfield-dev-australiaeast/providers/Microsoft.Storage/storageAccounts/stbfdev"
        infrastructure_encryption_enabled  = false
        is_hns_enabled                     = false
        large_file_share_enabled           = false
        local_user_enabled                 = true
        location                           = "australiaeast"
        min_tls_version                    = "TLS1_0"
        name                               = "stbfdev"
        nfsv3_enabled                      = false
        primary_access_key                 = (sensitive value)
        primary_blob_connection_string     = (sensitive value)
        primary_blob_endpoint              = "https://stbfdev.blob.core.windows.net/"
        primary_blob_host                  = "stbfdev.blob.core.windows.net"
        primary_blob_internet_endpoint     = null
        primary_blob_internet_host         = null
        primary_blob_microsoft_endpoint    = null
        primary_blob_microsoft_host        = null
        primary_connection_string          = (sensitive value)
        primary_dfs_endpoint               = "https://stbfdev.dfs.core.windows.net/"
        primary_dfs_host                   = "stbfdev.dfs.core.windows.net"
        primary_dfs_internet_endpoint      = null
        primary_dfs_internet_host          = null
        primary_dfs_microsoft_endpoint     = null
        primary_dfs_microsoft_host         = null
        primary_file_endpoint              = "https://stbfdev.file.core.windows.net/"
        primary_file_host                  = "stbfdev.file.core.windows.net"
        primary_file_internet_endpoint     = null
        primary_file_internet_host         = null
        primary_file_microsoft_endpoint    = null
        primary_file_microsoft_host        = null
        primary_location                   = "australiaeast"
        primary_queue_endpoint             = "https://stbfdev.queue.core.windows.net/"
        primary_queue_host                 = "stbfdev.queue.core.windows.net"
        primary_queue_microsoft_endpoint   = null
        primary_queue_microsoft_host       = null
        primary_table_endpoint             = "https://stbfdev.table.core.windows.net/"
        primary_table_host                 = "stbfdev.table.core.windows.net"
        primary_table_microsoft_endpoint   = null
        primary_table_microsoft_host       = null
        primary_web_endpoint               = "https://stbfdev.z8.web.core.windows.net/"
        primary_web_host                   = "stbfdev.z8.web.core.windows.net"
        primary_web_internet_endpoint      = null
        primary_web_internet_host          = null
        primary_web_microsoft_endpoint     = null
        primary_web_microsoft_host         = null
        public_network_access_enabled      = true
        queue_encryption_key_type          = "Service"
        resource_group_name                = "rg-brownfield-dev-australiaeast"
        secondary_access_key               = (sensitive value)
        secondary_blob_connection_string   = (sensitive value)
        secondary_blob_endpoint            = null
        secondary_blob_host                = null
        secondary_blob_internet_endpoint   = null
        secondary_blob_internet_host       = null
        secondary_blob_microsoft_endpoint  = null
        secondary_blob_microsoft_host      = null
        secondary_connection_string        = (sensitive value)
        secondary_dfs_endpoint             = null
        secondary_dfs_host                 = null
        secondary_dfs_internet_endpoint    = null
        secondary_dfs_internet_host        = null
        secondary_dfs_microsoft_endpoint   = null
        secondary_dfs_microsoft_host       = null
        secondary_file_endpoint            = null
        secondary_file_host                = null
        secondary_file_internet_endpoint   = null
        secondary_file_internet_host       = null
        secondary_file_microsoft_endpoint  = null
        secondary_file_microsoft_host      = null
        secondary_location                 = null
        secondary_queue_endpoint           = null
        secondary_queue_host               = null
        secondary_queue_microsoft_endpoint = null
        secondary_queue_microsoft_host     = null
        secondary_table_endpoint           = null
        secondary_table_host               = null
        secondary_table_microsoft_endpoint = null
        secondary_table_microsoft_host     = null
        secondary_web_endpoint             = null
        secondary_web_host                 = null
        secondary_web_internet_endpoint    = null
        secondary_web_internet_host        = null
        secondary_web_microsoft_endpoint   = null
        secondary_web_microsoft_host       = null
        sftp_enabled                       = false
        shared_access_key_enabled          = true
        table_encryption_key_type          = "Service"
        tags                               = {}

        blob_properties {
            change_feed_enabled           = false
            change_feed_retention_in_days = 0
            default_service_version       = null
            last_access_time_enabled      = false
            versioning_enabled            = false
        }

        queue_properties {
            hour_metrics {
                enabled               = false
                include_apis          = false
                retention_policy_days = 0
                version               = "1.0"
            }
            logging {
                delete                = false
                read                  = false
                retention_policy_days = 0
                version               = "1.0"
                write                 = false
            }
            minute_metrics {
                enabled               = false
                include_apis          = false
                retention_policy_days = 0
                version               = "1.0"
            }
        }

        share_properties {
            retention_policy {
                days = 7
            }
        }
    }
```

<!--
* there are no +/- indicators show, so we've managed to match the property values correctly.
-->
