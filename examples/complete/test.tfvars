

logical_product_family  = "launch"
logical_product_service = "monitor"
class_env               = "test"
instance_env            = 0
instance_resource       = 0

location = "eastus"

sku = "PerGB2018"

alert_description = "Alert when total requests with server errors exceed threshold"
enabled           = true

# KQL Query: Count requests with error code >= 500, grouped by 5-minute bins
query = "requests | where tolong(resultCode) >= 500 | summarize count() by bin(timestamp, 5m)"

severity    = 1
frequency   = 5
time_window = 30

trigger_operator  = "GreaterThan"
trigger_threshold = 3

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

email_subject          = "Azure Alert: Server Error Detected"
custom_webhook_payload = "{}"

authorized_resource_ids = []

tags = {
  environment = "test"
  terraform   = "true"
  purpose     = "monitor-scheduled-query-alert"
}
