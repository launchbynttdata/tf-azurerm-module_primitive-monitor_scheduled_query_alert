# complete

<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | ~> 1.5 |
| <a name="requirement_azurerm"></a> [azurerm](#requirement\_azurerm) | >= 4.69, < 5.0 |

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_application_insights"></a> [application\_insights](#module\_application\_insights) | terraform.registry.launch.nttdata.com/module_primitive/application_insights/azurerm | ~> 2.0 |
| <a name="module_log_analytics_workspace"></a> [log\_analytics\_workspace](#module\_log\_analytics\_workspace) | terraform.registry.launch.nttdata.com/module_primitive/log_analytics_workspace/azurerm | ~> 2.0 |
| <a name="module_monitor_action_group"></a> [monitor\_action\_group](#module\_monitor\_action\_group) | terraform.registry.launch.nttdata.com/module_primitive/monitor_action_group/azurerm | ~> 1.0 |
| <a name="module_resource_group"></a> [resource\_group](#module\_resource\_group) | terraform.registry.launch.nttdata.com/module_primitive/resource_group/azurerm | ~> 2.0 |
| <a name="module_resource_names"></a> [resource\_names](#module\_resource\_names) | terraform.registry.launch.nttdata.com/module_library/resource_name/launch | ~> 2.0 |
| <a name="module_scheduled_query_alert"></a> [scheduled\_query\_alert](#module\_scheduled\_query\_alert) | ../.. | n/a |

## Resources

No resources.

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_action_group_short_name"></a> [action\_group\_short\_name](#input\_action\_group\_short\_name) | Short name of the action group (max 12 characters) | `string` | `"AlertTeam"` | no |
| <a name="input_alert_description"></a> [alert\_description](#input\_alert\_description) | Description of the scheduled query alert | `string` | `"Alert when results exceed threshold"` | no |
| <a name="input_arm_role_receivers"></a> [arm\_role\_receivers](#input\_arm\_role\_receivers) | List of ARM role receivers for the action group | <pre>list(object({<br/>    name              = string<br/>    role_id           = string<br/>    use_common_schema = optional(bool, true)<br/>  }))</pre> | `[]` | no |
| <a name="input_auto_mitigation_enabled"></a> [auto\_mitigation\_enabled](#input\_auto\_mitigation\_enabled) | Whether Azure resolves the alert on its own once the condition clears | `bool` | `false` | no |
| <a name="input_class_env"></a> [class\_env](#input\_class\_env) | Environment classification | `string` | `"test"` | no |
| <a name="input_criteria"></a> [criteria](#input\_criteria) | The condition the rule evaluates. See the root module for the shape of each field. | <pre>object({<br/>    query                   = string<br/>    threshold               = number<br/>    operator                = optional(string, "GreaterThan")<br/>    time_aggregation_method = optional(string, "Count")<br/>    metric_measure_column   = optional(string)<br/>    resource_id_column      = optional(string)<br/>    dimensions = optional(list(object({<br/>      name     = string<br/>      values   = list(string)<br/>      operator = optional(string, "Include")<br/>    })), [])<br/>    failing_periods = optional(object({<br/>      minimum_failing_periods_to_trigger_alert = number<br/>      number_of_evaluation_periods             = number<br/>    }))<br/>  })</pre> | n/a | yes |
| <a name="input_custom_properties"></a> [custom\_properties](#input\_custom\_properties) | Properties to add to the alert payload | `map(string)` | `{}` | no |
| <a name="input_display_name"></a> [display\_name](#input\_display\_name) | Display name of the alert rule | `string` | `null` | no |
| <a name="input_email_receivers"></a> [email\_receivers](#input\_email\_receivers) | List of email receivers for the action group | <pre>list(object({<br/>    name                    = string<br/>    email_address           = string<br/>    use_common_alert_schema = optional(bool, true)<br/>  }))</pre> | `[]` | no |
| <a name="input_email_subject"></a> [email\_subject](#input\_email\_subject) | Subject override for emails sent by the action groups | `string` | `null` | no |
| <a name="input_enabled"></a> [enabled](#input\_enabled) | Whether the scheduled query alert rule is enabled | `bool` | `true` | no |
| <a name="input_evaluation_frequency"></a> [evaluation\_frequency](#input\_evaluation\_frequency) | How often the rule is evaluated, in ISO 8601 duration format | `string` | `"PT5M"` | no |
| <a name="input_instance_env"></a> [instance\_env](#input\_instance\_env) | Environment instance number | `number` | `0` | no |
| <a name="input_instance_resource"></a> [instance\_resource](#input\_instance\_resource) | Resource instance number | `number` | `0` | no |
| <a name="input_location"></a> [location](#input\_location) | Azure location (explicit location parameter for compatibility) | `string` | `"eastus"` | no |
| <a name="input_logical_product_family"></a> [logical\_product\_family](#input\_logical\_product\_family) | Logical product family name | `string` | `"launch"` | no |
| <a name="input_logical_product_service"></a> [logical\_product\_service](#input\_logical\_product\_service) | Logical product service name | `string` | `"monitor"` | no |
| <a name="input_mute_actions_after_alert_duration"></a> [mute\_actions\_after\_alert\_duration](#input\_mute\_actions\_after\_alert\_duration) | How long actions stay muted after the alert fires, in ISO 8601 duration format | `string` | `null` | no |
| <a name="input_resource_names_map"></a> [resource\_names\_map](#input\_resource\_names\_map) | A map of key to resource\_name that will be used by tf-launch-module\_library-resource\_name to generate resource names | <pre>map(object({<br/>    name       = string<br/>    max_length = optional(number, 60)<br/>  }))</pre> | <pre>{<br/>  "application_insights": {<br/>    "max_length": 260,<br/>    "name": "appi"<br/>  },<br/>  "log_analytics_workspace": {<br/>    "max_length": 63,<br/>    "name": "law"<br/>  },<br/>  "monitor_action_group": {<br/>    "max_length": 260,<br/>    "name": "mag"<br/>  },<br/>  "resource_group": {<br/>    "max_length": 80,<br/>    "name": "rg"<br/>  },<br/>  "scheduled_query_alert": {<br/>    "max_length": 260,<br/>    "name": "sqa"<br/>  }<br/>}</pre> | no |
| <a name="input_severity"></a> [severity](#input\_severity) | Severity of the alert (0-4) | `number` | `1` | no |
| <a name="input_sku"></a> [sku](#input\_sku) | Log Analytics Workspace SKU | `string` | `"PerGB2018"` | no |
| <a name="input_tags"></a> [tags](#input\_tags) | Tags to apply to resources | `map(string)` | <pre>{<br/>  "environment": "test",<br/>  "terraform": "true"<br/>}</pre> | no |
| <a name="input_window_duration"></a> [window\_duration](#input\_window\_duration) | Period of logs each evaluation looks at, in ISO 8601 duration format | `string` | `"PT30M"` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_application_insights_id"></a> [application\_insights\_id](#output\_application\_insights\_id) | The ID of the Application Insights component the rule is scoped to |
| <a name="output_log_analytics_workspace_id"></a> [log\_analytics\_workspace\_id](#output\_log\_analytics\_workspace\_id) | The ID of the Log Analytics Workspace |
| <a name="output_monitor_action_group_id"></a> [monitor\_action\_group\_id](#output\_monitor\_action\_group\_id) | The ID of the action group the alert invokes |
| <a name="output_resource_group_name"></a> [resource\_group\_name](#output\_resource\_group\_name) | The name of the resource group |
| <a name="output_scheduled_query_alert_id"></a> [scheduled\_query\_alert\_id](#output\_scheduled\_query\_alert\_id) | The ID of the scheduled query alert |
| <a name="output_scheduled_query_alert_name"></a> [scheduled\_query\_alert\_name](#output\_scheduled\_query\_alert\_name) | The name of the scheduled query alert |
<!-- END_TF_DOCS -->
