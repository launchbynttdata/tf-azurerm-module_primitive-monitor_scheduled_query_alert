# tf-azurerm-module_primitive-monitor_scheduled_query_alert

Manages an Azure Monitor scheduled query rule (`azurerm_monitor_scheduled_query_rules_alert_v2`).

## Upgrading from 1.x

2.0.0 moves from `azurerm_monitor_scheduled_query_rules_alert` to
`azurerm_monitor_scheduled_query_rules_alert_v2`. Microsoft directs new scheduled query rules at the
v2 API, and v1 rules are legacy Log Analytics rules on a deprecation path.

### Replacing the rule

The resource type changes, so there is no `moved` block that can carry state across: Terraform
destroys the v1 rule and creates a v2 one. Nothing but alert history is lost. The two resources are
unrelated addresses with no ordering between them, and both address the same ARM resource
`Microsoft.Insights/scheduledQueryRules/{name}`, so **if the new rule keeps the same `alert_name`,
the v2 create hits the provider's import check and fails while the v1 rule still exists.** The
provider will not overwrite the existing rule unless
`skip_import_check_on_create_and_allow_overwriting_existing_resources` is enabled in the `features`
block, which defaults off. The destroy of the v1 address is still unordered, so a failed same-name
apply can leave you with the old rule deleted and no replacement until you retry. Either give the v2
rule a different name, or apply the removal of the 1.x module call first and add the 2.x call in a
second apply.

### Input changes

| 1.x | 2.x |
|-----|-----|
| `data_source_id` | `scope_id` — one scope only, and changing it replaces the rule |
| `frequency` (minutes) | `evaluation_frequency` (ISO 8601, e.g. `PT5M`) |
| `time_window` (minutes) | `window_duration` (ISO 8601, e.g. `PT30M`) |
| `query`, `trigger_operator`, `trigger_threshold` | `criteria.query`, `criteria.operator`, `criteria.threshold`, plus `criteria.time_aggregation_method` |
| `custom_webhook_payload` (JSON string) | `custom_properties` (`map(string)`) |
| `authorized_resource_ids` | `identity` — grant the rule's identity Reader on the resources its query reads |
| — | `criteria.dimensions`, `criteria.failing_periods`, `criteria.metric_measure_column`, `criteria.resource_id_column` |
| — | `display_name`, `auto_mitigation_enabled`, `mute_actions_after_alert_duration`, `query_time_range_override`, `skip_query_validation`, `target_resource_types`, `workspace_alerts_storage_enabled` |

`custom_properties` is a replacement rather than a rename: v1's `custom_webhook_payload` was the
entire JSON body sent to a webhook receiver, while `custom_properties` is a flat `map(string)` of
properties added to the alert payload. A caller sending a structured webhook body cannot port it
across by reshaping the value — the alert payload is Azure's, and these are additions to it.

`email_subject` is unchanged in name but now requires azurerm 4.69 or later, which is where the
provider added it to the v2 `action` block. Its default is `null` rather than
`"Alert Notification"`, so emails use Azure's own subject unless you set one.

### Behavior worth knowing

- **Dimensions replace per-value queries.** Declaring a column in `criteria.dimensions` makes Azure
  evaluate the threshold separately for each of its values and fire one alert per value, so a query
  no longer has to encode the split itself. The query must project every dimension column.
- **`time_aggregation_method = "Count"` measures rows returned.** It cannot be combined with
  `metric_measure_column`; the other methods require one. A query that already aggregates with
  `summarize count()` wants `Total` or `Maximum` over `count_`, not `Count`.
- **Alerts do not resolve by default.** `auto_mitigation_enabled` defaults to `false`, matching the
  provider and 1.x behavior, so a fired alert stays fired. Set it to `true` for Azure to resolve the
  alert when the condition clears, or set `mute_actions_after_alert_duration` to re-notify on a fixed
  cadence instead. The two are mutually exclusive.
- **Azure validates the query against the scope on create.** A query referencing tables the scope has
  no schema for is rejected at apply time; `skip_query_validation` bypasses that check.

<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | ~> 1.5 |
| <a name="requirement_azurerm"></a> [azurerm](#requirement\_azurerm) | >= 4.69, < 5.0 |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [azurerm_monitor_scheduled_query_rules_alert_v2.scheduled_query_alert](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/monitor_scheduled_query_rules_alert_v2) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_action_group_ids"></a> [action\_group\_ids](#input\_action\_group\_ids) | List of action group resource IDs to invoke when the alert fires | `list(string)` | `[]` | no |
| <a name="input_alert_name"></a> [alert\_name](#input\_alert\_name) | Name of the scheduled query alert | `string` | n/a | yes |
| <a name="input_auto_mitigation_enabled"></a> [auto\_mitigation\_enabled](#input\_auto\_mitigation\_enabled) | Whether Azure resolves the alert on its own once the condition clears. When false the alert never<br/>resolves, so consumers that branch on monitorCondition never see a resolved notification. Mutually<br/>exclusive with mute\_actions\_after\_alert\_duration. | `bool` | `false` | no |
| <a name="input_criteria"></a> [criteria](#input\_criteria) | The condition the rule evaluates.<br/><br/>query:                   KQL query to run against the scope. Validated by Azure on create unless<br/>                         skip\_query\_validation is true.<br/>operator:                How threshold is compared. One of Equal, GreaterThan, GreaterThanOrEqual,<br/>                         LessThan, LessThanOrEqual.<br/>threshold:               Value that activates the alert.<br/>time\_aggregation\_method: What is measured. Count measures the number of rows the query returns;<br/>                         Average, Maximum, Minimum and Total aggregate metric\_measure\_column.<br/>metric\_measure\_column:   Column holding the number to aggregate. Required unless<br/>                         time\_aggregation\_method is Count, and forbidden when it is.<br/>resource\_id\_column:      Column holding a resource ID, so fired alerts attribute to that resource.<br/>dimensions:              Columns to split the evaluation by. Azure evaluates the threshold separately<br/>                         for each value and fires one alert per value, so the query must project each<br/>                         dimension column. Use ["*"] to match every value.<br/>failing\_periods:         How many of the last N evaluations must breach before the alert fires.<br/>                         Omit it to leave the default to Azure. Both fields accept 1 to 6, and<br/>                         number\_of\_evaluation\_periods must be 1 for queries that do not project a<br/>                         timestamp column. | <pre>object({<br/>    query                   = string<br/>    threshold               = number<br/>    operator                = optional(string, "GreaterThan")<br/>    time_aggregation_method = optional(string, "Count")<br/>    metric_measure_column   = optional(string)<br/>    resource_id_column      = optional(string)<br/>    dimensions = optional(list(object({<br/>      name     = string<br/>      values   = list(string)<br/>      operator = optional(string, "Include")<br/>    })), [])<br/>    failing_periods = optional(object({<br/>      minimum_failing_periods_to_trigger_alert = number<br/>      number_of_evaluation_periods             = number<br/>    }))<br/>  })</pre> | n/a | yes |
| <a name="input_custom_properties"></a> [custom\_properties](#input\_custom\_properties) | Properties to add to the alert payload. Replaces the v1 custom\_webhook\_payload JSON string. | `map(string)` | `{}` | no |
| <a name="input_description"></a> [description](#input\_description) | Description of the scheduled query alert | `string` | `""` | no |
| <a name="input_display_name"></a> [display\_name](#input\_display\_name) | Display name of the alert rule. Left unset when null, in which case Azure's own display behaviour applies. | `string` | `null` | no |
| <a name="input_email_subject"></a> [email\_subject](#input\_email\_subject) | Subject override for emails sent by the action groups. Azure's default subject is used when unset. | `string` | `null` | no |
| <a name="input_enabled"></a> [enabled](#input\_enabled) | Whether the scheduled query alert rule is enabled | `bool` | `true` | no |
| <a name="input_evaluation_frequency"></a> [evaluation\_frequency](#input\_evaluation\_frequency) | How often the rule is evaluated, in ISO 8601 duration format. One of PT1M, PT5M, PT10M, PT15M, PT30M,<br/>PT45M, PT1H, PT2H, PT3H, PT4H, PT5H, PT6H, P1D. Cannot exceed window\_duration *<br/>criteria.failing\_periods.number\_of\_evaluation\_periods, nor mute\_actions\_after\_alert\_duration. | `string` | `"PT5M"` | no |
| <a name="input_identity"></a> [identity](#input\_identity) | Managed identity the rule queries as. Replaces the v1 authorized\_resource\_ids input: grant this<br/>identity Reader on every resource a cross-resource query reads.<br/><br/>type:         SystemAssigned or UserAssigned.<br/>identity\_ids: User assigned identity IDs. Required when type is UserAssigned, and must be empty<br/>              for SystemAssigned. | <pre>object({<br/>    type         = string<br/>    identity_ids = optional(list(string), [])<br/>  })</pre> | `null` | no |
| <a name="input_location"></a> [location](#input\_location) | Azure region for the scheduled query alert | `string` | n/a | yes |
| <a name="input_mute_actions_after_alert_duration"></a> [mute\_actions\_after\_alert\_duration](#input\_mute\_actions\_after\_alert\_duration) | How long actions stay muted after the alert fires, in ISO 8601 duration format. One of PT5M, PT10M,<br/>PT15M, PT30M, PT45M, PT1H, PT2H, PT3H, PT4H, PT5H, PT6H, P1D, P2D. Set this to re-notify on a fixed<br/>cadence while a condition persists; requires auto\_mitigation\_enabled to be false. | `string` | `null` | no |
| <a name="input_query_time_range_override"></a> [query\_time\_range\_override](#input\_query\_time\_range\_override) | Query time range, when it should differ from window\_duration *<br/>criteria.failing\_periods.number\_of\_evaluation\_periods. One of PT5M, PT10M, PT15M, PT20M, PT30M, PT45M,<br/>PT1H, PT2H, PT3H, PT4H, PT5H, PT6H, P1D, P2D, and cannot be less than that product. | `string` | `null` | no |
| <a name="input_resource_group_name"></a> [resource\_group\_name](#input\_resource\_group\_name) | Name of the resource group | `string` | n/a | yes |
| <a name="input_scope_id"></a> [scope\_id](#input\_scope\_id) | Resource ID the rule is scoped to and whose logs the query runs against - a Log Analytics workspace,<br/>an Application Insights component, or any resource that sends logs to one. The Azure API accepts<br/>exactly one scope per rule. Changing this forces a new resource to be created. | `string` | n/a | yes |
| <a name="input_severity"></a> [severity](#input\_severity) | Severity of the alert (0, 1, 2, 3, 4). 0 is the most severe. | `number` | `1` | no |
| <a name="input_skip_query_validation"></a> [skip\_query\_validation](#input\_skip\_query\_validation) | Skip Azure's validation of criteria.query. Needed when the query references tables that do not exist in the scope yet. | `bool` | `false` | no |
| <a name="input_tags"></a> [tags](#input\_tags) | Tags to apply to the alert rule | `map(string)` | `{}` | no |
| <a name="input_target_resource_types"></a> [target\_resource\_types](#input\_target\_resource\_types) | Resource types within the scope to fire separate alerts for, e.g. Microsoft.Compute/virtualMachines<br/>when the scope is a resource group. | `list(string)` | `[]` | no |
| <a name="input_window_duration"></a> [window\_duration](#input\_window\_duration) | Period of logs each evaluation looks at (bin size), in ISO 8601 duration format. One of PT1M, PT5M,<br/>PT10M, PT15M, PT30M, PT45M, PT1H, PT2H, PT3H, PT4H, PT5H, PT6H, P1D, P2D. PT1M is only valid when<br/>evaluation\_frequency is PT1M. | `string` | `"PT30M"` | no |
| <a name="input_workspace_alerts_storage_enabled"></a> [workspace\_alerts\_storage\_enabled](#input\_workspace\_alerts\_storage\_enabled) | Whether the rule checks that alert storage is configured in the customer's own storage account | `bool` | `false` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_scheduled_query_alert_id"></a> [scheduled\_query\_alert\_id](#output\_scheduled\_query\_alert\_id) | The ID of the scheduled query alert rule |
| <a name="output_scheduled_query_alert_name"></a> [scheduled\_query\_alert\_name](#output\_scheduled\_query\_alert\_name) | The name of the scheduled query alert rule |
| <a name="output_scheduled_query_alert_principal_id"></a> [scheduled\_query\_alert\_principal\_id](#output\_scheduled\_query\_alert\_principal\_id) | Principal ID of the rule's SystemAssigned identity, for granting it read access to the resources its query reads. Null when no identity is configured, and empty for UserAssigned - Azure exposes no principal on the rule in that case, so grant access to the user assigned identity's own principal instead. |
<!-- END_TF_DOCS -->
