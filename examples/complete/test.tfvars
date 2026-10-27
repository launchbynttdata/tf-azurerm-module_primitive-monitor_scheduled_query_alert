
logical_product_family  = "launch"
logical_product_service = "monitor"
class_env               = "test"
instance_env            = 0
instance_resource       = 0

location = "eastus"

sku = "PerGB2018"

alert_description = "Alert when a role instance returns too many server errors"
display_name      = "Server errors by role"
enabled           = true
severity          = 1

evaluation_frequency = "PT5M"
window_duration      = "PT5M"

# Count the failing requests themselves and split the evaluation by role name, so Azure fires one
# alert per role rather than one alert for the whole component. The query projects cloud_RoleName
# because a dimension can only split on a column the query returns.
criteria = {
  query                   = "requests | where tolong(resultCode) >= 500 | project timestamp, cloud_RoleName"
  operator                = "GreaterThan"
  threshold               = 3
  time_aggregation_method = "Count"

  dimensions = [
    {
      name     = "cloud_RoleName"
      operator = "Include"
      values   = ["*"]
    }
  ]

  failing_periods = {
    minimum_failing_periods_to_trigger_alert = 1
    number_of_evaluation_periods             = 1
  }
}

# Re-notify hourly while a role keeps failing. Azure rejects muting unless auto mitigation is off.
auto_mitigation_enabled           = false
mute_actions_after_alert_duration = "PT1H"

action_group_short_name = "AlertTeam"

# Email receivers for action group
email_receivers = [
  {
    name                    = "Email"
    email_address           = "alerts@example.com"
    use_common_alert_schema = true
  }
]

arm_role_receivers = []

email_subject = "Azure Alert: Server Error Detected"

custom_properties = {
  alert_source = "monitor_scheduled_query_alert"
}

tags = {
  environment = "test"
  terraform   = "true"
  purpose     = "monitor-scheduled-query-alert"
}
