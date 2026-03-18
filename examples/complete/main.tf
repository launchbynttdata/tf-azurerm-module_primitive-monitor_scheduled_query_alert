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
  version = "~> 1.0"

  name     = module.resource_names["resource_group"].standard
  location = var.location

  tags = merge(var.tags, { resource_name = module.resource_names["resource_group"].standard })
}

module "log_analytics_workspace" {
  source  = "terraform.registry.launch.nttdata.com/module_primitive/log_analytics_workspace/azurerm"
  version = "~> 1.0"

  name                = module.resource_names["log_analytics_workspace"].standard
  location            = var.location
  resource_group_name = module.resource_group.name
  sku                 = var.sku

  tags = merge(var.tags, { resource_name = module.resource_names["log_analytics_workspace"].standard })

  depends_on = [module.resource_group]
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
  data_source_id      = module.log_analytics_workspace.id
  description         = var.alert_description
  enabled             = var.enabled
  query               = var.query
  severity            = var.severity
  frequency           = var.frequency
  time_window         = var.time_window

  trigger_operator  = var.trigger_operator
  trigger_threshold = var.trigger_threshold

  action_group_ids        = [module.monitor_action_group.action_group_id]
  email_subject           = var.email_subject
  custom_webhook_payload  = var.custom_webhook_payload
  authorized_resource_ids = var.authorized_resource_ids

  tags = merge(var.tags, { resource_name = module.resource_names["scheduled_query_alert"].standard })

  depends_on = [module.resource_group, module.log_analytics_workspace, module.monitor_action_group]
}
