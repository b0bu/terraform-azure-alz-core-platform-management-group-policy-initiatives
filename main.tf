resource "azurerm_policy_set_definition" "policy" {
  name         = var.name
  policy_type  = "Custom"
  display_name = var.properties.displayName

  parameters          = try(length(var.properties.parameters) > 0, false) ? jsonencode(var.properties.parameters) : null
  description         = try(var.properties.description, "${var.properties.displayName} Policy Set Definition at scope ${var.management_group_id}")
  management_group_id = var.management_group_id
  metadata            = try(length(var.properties.metadata) > 0, false) ? jsonencode(var.properties.metadata) : null


  dynamic "policy_definition_reference" {
    for_each = [ 
      // build dynamic list of map
      for item in var.properties.policyDefinitions :
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