output "deployed_initiative" {
  value = {
    name : azurerm_policy_set_definition.policy.name
    id : azurerm_policy_set_definition.policy.id
    display_name : azurerm_policy_set_definition.policy.display_name
    description : azurerm_policy_set_definition.policy.description
  }
}
