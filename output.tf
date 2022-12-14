output "deployed_initiative" {
    value = {
            name: azurerm_policy_set_definition.policy.name
            id: azurerm_policy_set_definition.policy.id
        }
}