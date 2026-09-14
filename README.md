# tf-azurerm-module_primitive-monitor_scheduled_query_alert

[![License](https://img.shields.io/badge/License-Apache_2.0-blue.svg)](https://opensource.org/licenses/Apache-2.0)
[![License: CC BY-NC-ND 4.0](https://img.shields.io/badge/License-CC_BY--NC--ND_4.0-lightgrey.svg)](https://creativecommons.org/licenses/by-nc-nd/4.0/)

## Overview

This Terraform module is used to create an Azure Monitor scheduled query alert.

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

### Pre-Requisites

The following commands should be available on your system:

- `asdf` or `mise`
- `make`
- `python3` (for pre-commit)

Additionally, your `git` user and email must be configured. Run the `make configure` command from the root of the repository to ensure that you meet these requirements.

### Pre-Commit hooks

The [.pre-commit-config.yaml](.pre-commit-config.yaml) file defines certain `pre-commit` hooks that are relevant to Terraform and Golang, as well as some common linting tasks. These will be configured for you when you run `make configure`.

### Local Validation

You should validate the changes you make to any module locally, prior to pushing your changes in a branch to GitHub.

1. Ensure that you have run `make configure` successfully.

2. Ensure you are signed into the appropriate cloud provider (e.g. AWS or Azure) for the module under test in your current console session.

3. Run the Terraform and Golang linters with the following command:

```
make lint
```

4. Once you have satisfied the linters, the following command will build example infrastructure in your configured cloud, run the tests, and then tear down the infrastructure it created:

```
make test
```

The pre-commit validations, as well as the `make lint` and `make test` targets, will all be performed in CI. Running these validations locally prior to opening a PR helps ensure a smooth review and merge process.

### Review and Merge Process

Once your change has been tested locally and your branch pushed up, open a new Pull Request for your branch to the default (main) branch of this repository.

The title of your Pull Request will determine the version bump for this change, and the title must be in [Conventional Commits](https://www.conventionalcommits.org/en/v1.0.0/#specification) format in order to merge. A breaking change will trigger a major version bump, a feature will trigger a minor version bump, and all other types will trigger a patch version bump.

Ensure your CI workflows are passing; seek approval from teammates and address any feedback; seek any explicit approvals required by the CODEOWNERS file. You may merge the PR as soon as all requirements are met, and a new release and tag will be automatically created for you.

### Automatic Updates

The shared configuration and workflow files in this repository are largely managed through the [launch-terraform-skeleton](https://github.com/launchbynttdata/launch-terraform-skeleton) repository. Outside of perhaps the `.gitignore` to account for specific files being generated by certain Terraform modules (e.g. Lambda functions), there should not be much cause to update these files on a per-repo basis, and making changes to them individually is discouraged.

If desired, you can check for and run these updates locally in a branch if you have the `copier` tool installed. Some example commands are included below:

```
# Check for updates, optionally checking prerelease versions
copier check-update [--prereleases]

# Run an update, using default answers if there are any. We use tasks, which requires --trust to be set.
copier update --defaults --trust [--prereleases]

# Recopy from the source, and --overwrite all templated files in the process
copier recopy --defaults --trust --overwrite [--prereleases]
```

Automatic updates will run through a scheduled workflow, and if the post-update tests are successful, the Pull Request created will automatically merge. Conflicts in the update or failures to test may leave a Pull Request outstanding, which needs to be addressed by a Launch Engineer.

## Usage

```hcl
module "monitor_scheduled_query_alert" {
	source = "terraform.registry.launch.nttdata.com/module_primitive/monitor_scheduled_query_alert/azurerm"

	alert_name          = "example-alert"
	resource_group_name = "example-rg"
	location            = "eastus"
	data_source_id      = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/example-rg/providers/Microsoft.OperationalInsights/workspaces/example-law"
	query               = "requests | where tolong(resultCode) >= 500 | summarize count() by bin(timestamp, 5m)"
}
```
