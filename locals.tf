##################################################
# locals for tagging
##################################################

locals {
  common_tags = {
    Owner       = var.owner
    Environment = var.environment
    Cost_center = var.cost_center
    Application = var.app_name
  }
}