resource "azurerm_resource_group" "this"{
    name = "anurag1"
    location = "central india"
}
resource "azurerm_storage_account" "this1"{
    name = "b18anuragg7"
    resource_group_name = azurerm_resource_group.this.name
    location = "azurerm_resource_group.this.location"
    account_tier = "standard"
    account_replication_type = "LRS"
}

