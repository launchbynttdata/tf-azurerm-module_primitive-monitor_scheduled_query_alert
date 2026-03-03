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

variable "resource_names_map" {
  description = "A map of key to resource_name that will be used by tf-launch-module_library-resource_name to generate resource names"
  type = map(object({
    name       = string
    max_length = optional(number, 60)
  }))

  default = {
    resource_group = {
      name       = "rg"
      max_length = 80
    }
    log_analytics_workspace = {
      name       = "law"
      max_length = 63
    }
    application_insights = {
      name       = "appi"
      max_length = 260
    }
    monitor_action_group = {
      name       = "mag"
      max_length = 260
    }
    scheduled_query_alert = {
      name       = "sqa"
      max_length = 260
    }
  }
}

variable "logical_product_family" {
  type        = string
  description = "Logical product family name"
  default     = "launch"
}

variable "logical_product_service" {
  type        = string
  description = "Logical product service name"
  default     = "monitor"
}

variable "class_env" {
  type        = string
  description = "Environment classification"
  default     = "test"
}

variable "instance_env" {
  type        = number
  description = "Environment instance number"
  default     = 0
}

variable "instance_resource" {
  type        = number
  description = "Resource instance number"
  default     = 0
}

variable "location" {
  type        = string
  description = "Azure location (explicit location parameter for compatibility)"
  default     = "eastus"
}

variable "sku" {
  type        = string
  description = "Log Analytics Workspace SKU"
  default     = "PerGB2018"
}

variable "application_type" {
  type        = string
  description = "Application Insights application type"
  default     = "web"
}

variable "action_group_short_name" {
  description = "Short name of the action group (max 12 characters)"
  type        = string
  default     = "AlertTeam"
}

variable "arm_role_receivers" {
  description = "List of ARM role receivers for the action group"
  type = list(object({
    name              = string
    role_id           = string
    use_common_schema = optional(bool, true)
  }))
  default = []
}

variable "email_receivers" {
  description = "List of email receivers for the action group"
  type = list(object({
    name                    = string
    email_address           = string
    use_common_alert_schema = optional(bool, true)
  }))
  default = []
}

variable "tags" {
  type        = map(string)
  description = "Tags to apply to resources"
  default = {
    environment = "test"
    terraform   = "true"
  }
}

variable "alert_description" {
  description = "Description of the scheduled query alert"
  type        = string
  default     = "Alert when results exceed threshold"
}

variable "enabled" {
  description = "Whether the scheduled query alert rule is enabled"
  type        = bool
  default     = true
}

variable "query" {
  description = "The KQL query string to evaluate"
  type        = string
  default     = "requests | where tolong(resultCode) >= 500 | summarize count() by bin(timestamp, 5m)"
}

variable "severity" {
  description = "Severity of the alert (0-4)"
  type        = number
  default     = 1
}

variable "frequency" {
  description = "Frequency of evaluation in minutes (5, 10, 15, 30, 45, 60)"
  type        = number
  default     = 5
}

variable "time_window" {
  description = "Time window in minutes for data evaluation"
  type        = number
  default     = 30
}

variable "trigger_operator" {
  description = "Operator for the alert rule trigger (GreaterThan, LessThan, Equal)"
  type        = string
  default     = "GreaterThan"
}

variable "trigger_threshold" {
  description = "Alert rule trigger threshold value"
  type        = number
  default     = 3
}

variable "email_subject" {
  description = "Email subject for alert notifications"
  type        = string
  default     = "Alert Notification from Azure"
}

variable "custom_webhook_payload" {
  description = "Custom webhook payload JSON string"
  type        = string
  default     = "{}"
}

variable "authorized_resource_ids" {
  description = "List of authorized resource IDs for cross-resource queries"
  type        = list(string)
  default     = []
}
