locals {
  // the value assigned to the tf output
  // can this be simplified, i.e. no specific requires_id or
  // output = azurerm_policy_set_definition.policy
  # output = {
  #   requires_identity = {
  #       for policy in local.set_definition_ids : 
  #         policy.name => policy.id
  #   }
  #   no_required_identity = {}
  # }

  templated_policy_initiatives = var.policy_initiatives

  set_definition_ids = azurerm_policy_set_definition.policy

  common_template_values = {
    scope    = var.management_group_id
    location = "uksouth"
  }
}

resource "azurerm_policy_set_definition" "policy" {
  for_each = local.templated_policy_initiatives

  name         = each.value.name
  policy_type  = "Custom"
  display_name = each.value.properties.displayName

  parameters          = try(length(each.value.properties.parameters) > 0, false) ? jsonencode(each.value.properties.parameters) : null
  description         = try(each.value.properties.description, "${each.value.properties.displayName} Policy Set Definition at scope ${each.value.scope_id}")
  management_group_id = try(each.value.scope_id, local.common_template_values.scope)
  metadata            = try(length(each.value.properties.metadata) > 0, false) ? jsonencode(each.value.properties.metadata) : null


  dynamic "policy_definition_reference" {
    for_each = [ 
      // build dynamic list of map
      for item in each.value.properties.policyDefinitions :
      {
        policyDefinitionId          = item.policyDefinitionId
        # Optional resource attributes
        parameters                  = try(jsonencode(item.parameters), null)
        policyDefinitionReferenceId = try(item.policyDefinitionReferenceId, null)
      }
    ]
    content { 
      // actual hcl properties for policy_definition_reference resource
      policy_definition_id = policy_definition_reference.value["policyDefinitionId"]
      parameter_values     = policy_definition_reference.value["parameters"]
      reference_id         = policy_definition_reference.value["policyDefinitionReferenceId"]
    }
  }
}