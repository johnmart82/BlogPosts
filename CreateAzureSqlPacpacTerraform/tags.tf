# Use a map variable to perform lookup against a valid set of values.
# Locals will be used to collapse the map into a single command
# that can configure multiple tags in a resource without the 
# need to explicitly manage multiple tags in all resources.
locals {
  default_tags = {
    Environment = var.Environment
    Usage       = var.Usage
    CreatedDate = timestamp()
  }

  tags = merge(local.default_tags)
}