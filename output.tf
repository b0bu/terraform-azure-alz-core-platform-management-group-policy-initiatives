# output "deployed_initiatives" {
#     value = local.output
# }

# output "deployed_initiatives" {
#     value = {
#     for policy in azurerm_policy_set_definition.policy : 
#           policy.name => policy.id
#     }
# }


# locals {
#     value = [
#        for policy in azurerm_policy_set_definition.policy : 
#         {
#             name: policy.name
#             id: policy.id
#         }
#     ]
# }

#   initiatives_with_managed_identity = [{
#     for policy_name, id in module.myorg_root_management_group_policy_initiatives.deployed_initiatives :
#     policy_name => {
#       name = policy_name
#       id   = id
#     } if contains(keys(local.azurerm_role_assignments), policy_name)
#   }]

// has to be a key to use name id = 
output "deployed_initiatives" {
    value = [
       for policy in azurerm_policy_set_definition.policy : 
        {
            name: policy.name
            id: policy.id
        }
    ]
}