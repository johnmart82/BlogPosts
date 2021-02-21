variable "ResourceGroupName" {
  type        = string
  description = "Please provide a name for the resource group."
}
variable "ResourceGroupLocation" {
  type        = string
  description = "Please provide an Azure region for the resource group."
}

# Variables that need to be supplied for the tags.
variable "CostCentre" {
  description = "Please provide a cost center for the resource to be allocated to."
}

variable "Environment" {
  description = "Please provide details on the environment that the resource is assigned to."
}

variable "Contact" {
  description = "Please provide a contact that is responsible for this resource, this should be a valid distribution email list."
}

variable "Usage" {
  description = "Please provide some context for what the resources are being used for."
}