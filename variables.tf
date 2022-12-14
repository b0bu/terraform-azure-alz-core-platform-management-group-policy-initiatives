variable "management_group_id" {
  type        = string
  description = "scope at which to apply the policy"
}

variable "policy_initiatives" {
  type        = map
  description = "hcl templated policy initiatives output from policy-factory"
  default = {}
}