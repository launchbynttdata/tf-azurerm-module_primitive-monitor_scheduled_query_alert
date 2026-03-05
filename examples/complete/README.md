# complete

<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | ~> 1.5 |
| <a name="requirement_azurerm"></a> [azurerm](#requirement\_azurerm) | ~> 3.117 |

## Providers

No providers.

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_resource_names"></a> [resource\_names](#module\_resource\_names) | terraform.registry.launch.nttdata.com/module_library/resource_name/launch | ~> 2.0 |
| <a name="module_resource_group"></a> [resource\_group](#module\_resource\_group) | terraform.registry.launch.nttdata.com/module_primitive/resource_group/azurerm | ~> 1.0 |
| <a name="module_log_analytics_workspace"></a> [log\_analytics\_workspace](#module\_log\_analytics\_workspace) | terraform.registry.launch.nttdata.com/module_primitive/log_analytics_workspace/azurerm | ~> 1.0 |
| <a name="module_monitor_action_group"></a> [monitor\_action\_group](#module\_monitor\_action\_group) | terraform.registry.launch.nttdata.com/module_primitive/monitor_action_group/azurerm | ~> 1.0 |
| <a name="module_scheduled_query_alert"></a> [scheduled\_query\_alert](#module\_scheduled\_query\_alert) | ../.. | n/a |

## Resources

No resources.

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_resource_names_map"></a> [resource\_names\_map](#input\_resource\_names\_map) | A map of key to resource\_name that will be used by tf-launch-module\_library-resource\_name to generate resource names | <pre>map(object({<br/>    name       = string<br/>    max_length = optional(number, 60)<br/>  }))</pre> | <pre>{<br/>  "log_analytics_workspace": {<br/>    "max_length": 63,<br/>    "name": "law"<br/>  },<br/>  "monitor_action_group": {<br/>    "max_length": 260,<br/>    "name": "mag"<br/>  },<br/>  "resource_group": {<br/>    "max_length": 80,<br/>    "name": "rg"<br/>  },<br/>  "scheduled_query_alert": {<br/>    "max_length": 260,<br/>    "name": "sqa"<br/>  }<br/>}</pre> | no |
| <a name="input_logical_product_family"></a> [logical\_product\_family](#input\_logical\_product\_family) | Logical product family name | `string` | `"launch"` | no |
| <a name="input_logical_product_service"></a> [logical\_product\_service](#input\_logical\_product\_service) | Logical product service name | `string` | `"monitor"` | no |
| <a name="input_class_env"></a> [class\_env](#input\_class\_env) | Environment classification | `string` | `"test"` | no |
| <a name="input_instance_env"></a> [instance\_env](#input\_instance\_env) | Environment instance number | `number` | `0` | no |
| <a name="input_instance_resource"></a> [instance\_resource](#input\_instance\_resource) | Resource instance number | `number` | `0` | no |
| <a name="input_location"></a> [location](#input\_location) | Azure location (explicit location parameter for compatibility) | `string` | `"eastus"` | no |
| <a name="input_sku"></a> [sku](#input\_sku) | Log Analytics Workspace SKU | `string` | `"PerGB2018"` | no |
| <a name="input_action_group_short_name"></a> [action\_group\_short\_name](#input\_action\_group\_short\_name) | Short name of the action group (max 12 characters) | `string` | `"AlertTeam"` | no |
| <a name="input_arm_role_receivers"></a> [arm\_role\_receivers](#input\_arm\_role\_receivers) | List of ARM role receivers for the action group | <pre>list(object({<br/>    name              = string<br/>    role_id           = string<br/>    use_common_schema = optional(bool, true)<br/>  }))</pre> | `[]` | no |
| <a name="input_email_receivers"></a> [email\_receivers](#input\_email\_receivers) | List of email receivers for the action group | <pre>list(object({<br/>    name                    = string<br/>    email_address           = string<br/>    use_common_alert_schema = optional(bool, true)<br/>  }))</pre> | `[]` | no |
| <a name="input_tags"></a> [tags](#input\_tags) | Tags to apply to resources | `map(string)` | <pre>{<br/>  "environment": "test",<br/>  "terraform": "true"<br/>}</pre> | no |
| <a name="input_alert_description"></a> [alert\_description](#input\_alert\_description) | Description of the scheduled query alert | `string` | `"Alert when results exceed threshold"` | no |
| <a name="input_enabled"></a> [enabled](#input\_enabled) | Whether the scheduled query alert rule is enabled | `bool` | `true` | no |
| <a name="input_query"></a> [query](#input\_query) | The KQL query string to evaluate | `string` | `"requests | where tolong(resultCode) >= 500 | summarize count() by bin(timestamp, 5m)"` | no |
| <a name="input_severity"></a> [severity](#input\_severity) | Severity of the alert (0-4) | `number` | `1` | no |
| <a name="input_frequency"></a> [frequency](#input\_frequency) | Frequency of evaluation in minutes (5, 10, 15, 30, 45, 60) | `number` | `5` | no |
| <a name="input_time_window"></a> [time\_window](#input\_time\_window) | Time window in minutes for data evaluation. Must be between 5 and 2880 and greater than or equal to frequency. | `number` | `30` | no |
| <a name="input_trigger_operator"></a> [trigger\_operator](#input\_trigger\_operator) | Operator for the alert rule trigger (GreaterThan, LessThan, Equal) | `string` | `"GreaterThan"` | no |
| <a name="input_trigger_threshold"></a> [trigger\_threshold](#input\_trigger\_threshold) | Alert rule trigger threshold value | `number` | `3` | no |
| <a name="input_email_subject"></a> [email\_subject](#input\_email\_subject) | Email subject for alert notifications | `string` | `"Alert Notification from Azure"` | no |
| <a name="input_custom_webhook_payload"></a> [custom\_webhook\_payload](#input\_custom\_webhook\_payload) | Custom webhook payload JSON string | `string` | `"{}"` | no |
| <a name="input_authorized_resource_ids"></a> [authorized\_resource\_ids](#input\_authorized\_resource\_ids) | List of authorized resource IDs for cross-resource queries | `list(string)` | `[]` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_scheduled_query_alert_id"></a> [scheduled\_query\_alert\_id](#output\_scheduled\_query\_alert\_id) | The ID of the scheduled query alert |
| <a name="output_scheduled_query_alert_name"></a> [scheduled\_query\_alert\_name](#output\_scheduled\_query\_alert\_name) | The name of the scheduled query alert |
| <a name="output_log_analytics_workspace_id"></a> [log\_analytics\_workspace\_id](#output\_log\_analytics\_workspace\_id) | The ID of the Log Analytics Workspace |
| <a name="output_monitor_action_group_id"></a> [monitor\_action\_group\_id](#output\_monitor\_action\_group\_id) | n/a |
<!-- END_TF_DOCS -->
