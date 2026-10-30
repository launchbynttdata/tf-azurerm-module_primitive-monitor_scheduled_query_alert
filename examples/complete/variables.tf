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

variable "display_name" {
  description = "Display name of the alert rule"
  type        = string
  default     = null
}

variable "enabled" {
  description = "Whether the scheduled query alert rule is enabled"
  type        = bool
  default     = true
}

variable "severity" {
  description = "Severity of the alert (0-4)"
  type        = number
  default     = 1
}

variable "evaluation_frequency" {
  description = "How often the rule is evaluated, in ISO 8601 duration format"
  type        = string
  default     = "PT5M"
}

variable "window_duration" {
  description = "Period of logs each evaluation looks at, in ISO 8601 duration format"
  type        = string
  default     = "PT30M"
}

variable "criteria" {
  description = "The condition the rule evaluates. See the root module for the shape of each field."
  type = object({
    query                   = string
    threshold               = number
    operator                = optional(string, "GreaterThan")
    time_aggregation_method = optional(string, "Count")
    metric_measure_column   = optional(string)
    resource_id_column      = optional(string)
    dimensions = optional(list(object({
      name     = string
      values   = list(string)
      operator = optional(string, "Include")
    })), [])
    failing_periods = optional(object({
      minimum_failing_periods_to_trigger_alert = number
      number_of_evaluation_periods             = number
    }))
  })
}

variable "auto_mitigation_enabled" {
  description = "Whether Azure resolves the alert on its own once the condition clears"
  type        = bool
  default     = false
}

variable "mute_actions_after_alert_duration" {
  description = "How long actions stay muted after the alert fires, in ISO 8601 duration format"
  type        = string
  default     = null
}

variable "email_subject" {
  description = "Subject override for emails sent by the action groups"
  type        = string
  default     = null
}

variable "custom_properties" {
  description = "Properties to add to the alert payload"
  type        = map(string)
  default     = {}
}
