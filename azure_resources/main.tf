resource "azurerm_resource_group" "this"{
    name = "anurag1"
    location = "Central India"
}
resource "azurerm_storage_account" "this1"{
    name = "b18anuragg7"
    resource_group_name = azurerm_resource_group.this.name
    location = azurerm_resource_group.this.location
    account_tier = "Standard"
    account_replication_type = "LRS"
    
    network_rules {
    default_action = "Deny"
    bypass = [
        "AzureServices"
    ]
    }
    
    min_tls_version      = "TLS1_2"
    
    queue_properties  {
    logging {
        delete                = true
        read                  = true
        write                 = true
        version               = "1.0"
        retention_policy_days = 10
    }
}
https_traffic_only_enabled = true
}

