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

resource "azurerm_monitor_scheduled_query_rules_alert" "scheduled_query_alert" {
  name                = var.alert_name
  resource_group_name = var.resource_group_name
  location            = var.location

  data_source_id          = var.data_source_id
  description             = var.description
  enabled                 = var.enabled
  query                   = var.query
  severity                = var.severity
  frequency               = var.frequency
  time_window             = var.time_window
  authorized_resource_ids = var.authorized_resource_ids

  action {
    action_group           = var.action_group_ids
    email_subject          = var.email_subject
    custom_webhook_payload = var.custom_webhook_payload
  }

  trigger {
    operator  = var.trigger_operator
    threshold = var.trigger_threshold
  }

  tags = var.tags
}
