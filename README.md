# tf-azurerm-module_primitive-monitor_scheduled_query_alert

## Overview

This module creates an Azure Monitor scheduled query alert rule with configurable query, trigger, severity, and action group integration.

## Usage

```hcl
module "monitor_scheduled_query_alert" {
	source = "terraform.registry.launch.nttdata.com/module_primitive/monitor_scheduled_query_alert/azurerm"

	resource_group_name = "example-rg"
	location            = "eastus"
	alert_name          = "example-scheduled-query-alert"
	data_source_id      = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/example-rg/providers/Microsoft.OperationalInsights/workspaces/example-law"

	description       = "Alert when server errors exceed threshold"
	query             = "requests | where tolong(resultCode) >= 500 | summarize count() by bin(timestamp, 5m)"
	trigger_operator  = "GreaterThan"
	trigger_threshold = 3

	action_group_ids = [
		"/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/example-rg/providers/microsoft.insights/actionGroups/example-action-group"
	]
}
```

<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | ~> 1.5 |
| <a name="requirement_azurerm"></a> [azurerm](#requirement\_azurerm) | ~>3.117 |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [azurerm_monitor_scheduled_query_rules_alert.scheduled_query_alert](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/monitor_scheduled_query_rules_alert) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_action_group_ids"></a> [action\_group\_ids](#input\_action\_group\_ids) | List of action group resource IDs to associate with the alert | `list(string)` | `[]` | no |
| <a name="input_alert_name"></a> [alert\_name](#input\_alert\_name) | Name of the scheduled query alert | `string` | n/a | yes |
| <a name="input_authorized_resource_ids"></a> [authorized\_resource\_ids](#input\_authorized\_resource\_ids) | List of authorized resource IDs for cross-resource queries | `list(string)` | `[]` | no |
| <a name="input_custom_webhook_payload"></a> [custom\_webhook\_payload](#input\_custom\_webhook\_payload) | Custom webhook payload JSON string | `string` | `"{}"` | no |
| <a name="input_data_source_id"></a> [data\_source\_id](#input\_data\_source\_id) | The ID of the resource | `string` | n/a | yes |
| <a name="input_description"></a> [description](#input\_description) | Description of the scheduled query alert | `string` | `""` | no |
| <a name="input_email_subject"></a> [email\_subject](#input\_email\_subject) | Email subject for alert notifications | `string` | `"Alert Notification"` | no |
| <a name="input_enabled"></a> [enabled](#input\_enabled) | Whether the scheduled query alert rule is enabled | `bool` | `true` | no |
| <a name="input_frequency"></a> [frequency](#input\_frequency) | Frequency of evaluation in minutes (5, 10, 15, 30, 45, 60) | `number` | `5` | no |
| <a name="input_location"></a> [location](#input\_location) | Azure region for the scheduled query alert | `string` | n/a | yes |
| <a name="input_query"></a> [query](#input\_query) | The KQL query string to evaluate | `string` | n/a | yes |
| <a name="input_resource_group_name"></a> [resource\_group\_name](#input\_resource\_group\_name) | Name of the resource group | `string` | n/a | yes |
| <a name="input_severity"></a> [severity](#input\_severity) | Severity of the alert (0, 1, 2, 3, 4) | `number` | `1` | no |
| <a name="input_tags"></a> [tags](#input\_tags) | Tags to apply to the alert rule | `map(string)` | `{}` | no |
| <a name="input_time_window"></a> [time\_window](#input\_time\_window) | Time window in minutes for data evaluation. Must be between 5 and 2880 and greater than or equal to frequency. | `number` | `30` | no |
| <a name="input_trigger_operator"></a> [trigger\_operator](#input\_trigger\_operator) | Operator for the alert rule trigger (GreaterThan, LessThan, Equal, GreaterThanOrEqual, LessThanOrEqual) | `string` | `"GreaterThan"` | no |
| <a name="input_trigger_threshold"></a> [trigger\_threshold](#input\_trigger\_threshold) | Alert rule trigger threshold value | `number` | `0` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_scheduled_query_alert_id"></a> [scheduled\_query\_alert\_id](#output\_scheduled\_query\_alert\_id) | The ID of the scheduled query alert rule |
| <a name="output_scheduled_query_alert_name"></a> [scheduled\_query\_alert\_name](#output\_scheduled\_query\_alert\_name) | The name of the scheduled query alert rule |
<!-- END_TF_DOCS -->

## Module Development

Use this repository as a standard Launch Terraform primitive module.

- Keep examples and tests aligned with code changes because they are part of the public contract.
- Preserve generated files and automation patterns from the shared skeleton unless a module-specific exception is required.
- Prefer make targets and pre-commit hooks over ad hoc commands to match CI behavior.

## Pre-Requisites

The following commands should be available on your system:

- asdf or mise
- make
- python3 (for pre-commit)

Install pinned tool versions and bootstrap dependencies from the repository root:

```sh
make configure
```

## Pre-Commit Hooks

This repository uses [.pre-commit-config.yaml](.pre-commit-config.yaml) to run Terraform, Go, and repository hygiene checks.

Install local hooks:

```sh
pre-commit install --hook-type commit-msg
```

Run all hooks manually:

```sh
pre-commit run --all-files
```

## Local Validation

Run the same validations used in CI:

```sh
make lint
make check
```

If a hook or generated file changes content (for example terraform-docs), commit the updates and rerun the checks.

## Review And Merge Process

- Open a pull request with a clear summary of functional and test-impacting changes.
- Resolve all review comments and ensure CI is green before merge.
- Keep commits focused and use conventional commit messages when possible.

## Automatic Updates

This repository receives periodic updates from the shared launch-terraform-skeleton baseline via Copier automation. Keep skeleton-managed files aligned with upstream expectations so automated updates continue to merge cleanly.
