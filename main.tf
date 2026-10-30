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

resource "azurerm_monitor_scheduled_query_rules_alert_v2" "scheduled_query_alert" {
  name                = var.alert_name
  resource_group_name = var.resource_group_name
  location            = var.location

  scopes               = [var.scope_id]
  severity             = var.severity
  evaluation_frequency = var.evaluation_frequency
  window_duration      = var.window_duration

  description  = var.description
  display_name = var.display_name
  enabled      = var.enabled

  auto_mitigation_enabled           = var.auto_mitigation_enabled
  mute_actions_after_alert_duration = var.mute_actions_after_alert_duration
  query_time_range_override         = var.query_time_range_override
  skip_query_validation             = var.skip_query_validation
  target_resource_types             = var.target_resource_types
  workspace_alerts_storage_enabled  = var.workspace_alerts_storage_enabled

  criteria {
    query                   = var.criteria.query
    operator                = var.criteria.operator
    threshold               = var.criteria.threshold
    time_aggregation_method = var.criteria.time_aggregation_method
    metric_measure_column   = var.criteria.metric_measure_column
    resource_id_column      = var.criteria.resource_id_column

    dynamic "dimension" {
      for_each = var.criteria.dimensions

      content {
        name     = dimension.value.name
        operator = dimension.value.operator
        values   = dimension.value.values
      }
    }

    dynamic "failing_periods" {
      for_each = var.criteria.failing_periods == null ? [] : [var.criteria.failing_periods]

      content {
        minimum_failing_periods_to_trigger_alert = failing_periods.value.minimum_failing_periods_to_trigger_alert
        number_of_evaluation_periods             = failing_periods.value.number_of_evaluation_periods
      }
    }
  }

  dynamic "action" {
    for_each = local.emit_action ? [1] : []

    content {
      action_groups     = var.action_group_ids
      custom_properties = var.custom_properties
      email_subject     = var.email_subject
    }
  }

  dynamic "identity" {
    for_each = var.identity == null ? [] : [var.identity]

    content {
      type         = identity.value.type
      identity_ids = identity.value.identity_ids
    }
  }

  tags = var.tags

  lifecycle {
    # Azure rejects the combination, and the provider only catches it mid-apply.
    precondition {
      condition     = var.mute_actions_after_alert_duration == null || !var.auto_mitigation_enabled
      error_message = "auto_mitigation_enabled must be false when mute_actions_after_alert_duration is set."
    }
  }
}
