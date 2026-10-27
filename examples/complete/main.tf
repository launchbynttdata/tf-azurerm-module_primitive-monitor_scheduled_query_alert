// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at
//
//     http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.

module "resource_names" {
  source  = "terraform.registry.launch.nttdata.com/module_library/resource_name/launch"
  version = "~> 2.0"

  for_each = var.resource_names_map

  region                  = join("", split("-", var.location))
  class_env               = var.class_env
  cloud_resource_type     = each.value.name
  instance_env            = var.instance_env
  instance_resource       = var.instance_resource
  maximum_length          = each.value.max_length
  logical_product_family  = var.logical_product_family
  logical_product_service = var.logical_product_service
}

module "resource_group" {
  source  = "terraform.registry.launch.nttdata.com/module_primitive/resource_group/azurerm"
  version = "~> 2.0"

  name     = module.resource_names["resource_group"].standard
  location = var.location

  tags = merge(var.tags, { resource_name = module.resource_names["resource_group"].standard })
}

module "log_analytics_workspace" {
  source  = "terraform.registry.launch.nttdata.com/module_primitive/log_analytics_workspace/azurerm"
  version = "~> 2.0"

  name                = module.resource_names["log_analytics_workspace"].standard
  location            = var.location
  resource_group_name = module.resource_group.name
  sku                 = var.sku

  tags = merge(var.tags, { resource_name = module.resource_names["log_analytics_workspace"].standard })

  depends_on = [module.resource_group]
}

# The rule is scoped to Application Insights rather than the workspace directly: Azure validates
# criteria.query against the scope's schema on create, and the requests table only resolves for an
# Application Insights scope.
module "application_insights" {
  source  = "terraform.registry.launch.nttdata.com/module_primitive/application_insights/azurerm"
  version = "~> 2.0"

  name                = module.resource_names["application_insights"].standard
  location            = var.location
  resource_group_name = module.resource_group.name
  workspace_id        = module.log_analytics_workspace.id

  tags = merge(var.tags, { resource_name = module.resource_names["application_insights"].standard })

  depends_on = [module.log_analytics_workspace]
}

module "monitor_action_group" {
  source  = "terraform.registry.launch.nttdata.com/module_primitive/monitor_action_group/azurerm"
  version = "~> 1.0"

  action_group_name   = module.resource_names["monitor_action_group"].standard
  resource_group_name = module.resource_group.name
  short_name          = var.action_group_short_name
  arm_role_receivers  = var.arm_role_receivers
  email_receivers     = var.email_receivers

  tags = merge(var.tags, { resource_name = module.resource_names["monitor_action_group"].standard })

  depends_on = [module.resource_group]
}

module "scheduled_query_alert" {
  source = "../.."

  resource_group_name = module.resource_group.name
  location            = var.location
  alert_name          = module.resource_names["scheduled_query_alert"].standard
  scope_id            = module.application_insights.id
  description         = var.alert_description
  display_name        = var.display_name
  enabled             = var.enabled
  severity            = var.severity

  evaluation_frequency = var.evaluation_frequency
  window_duration      = var.window_duration

  criteria = var.criteria

  # Re-notify every hour while the condition persists, per failing site.
  auto_mitigation_enabled           = var.auto_mitigation_enabled
  mute_actions_after_alert_duration = var.mute_actions_after_alert_duration

  action_group_ids  = [module.monitor_action_group.action_group_id]
  email_subject     = var.email_subject
  custom_properties = var.custom_properties

  tags = merge(var.tags, { resource_name = module.resource_names["scheduled_query_alert"].standard })

  depends_on = [module.resource_group, module.application_insights, module.monitor_action_group]
}
