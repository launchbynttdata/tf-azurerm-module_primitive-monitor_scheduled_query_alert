variable "resource_group_name" {
  description = "Name of the resource group"
  type        = string
}

variable "location" {
  description = "Azure region for the scheduled query alert"
  type        = string
}

variable "alert_name" {
  description = "Name of the scheduled query alert"
  type        = string
}

variable "data_source_id" {
  description = "The ID of the resource"
  type        = string
}

variable "description" {
  description = "Description of the scheduled query alert"
  type        = string
  default     = ""
}

variable "enabled" {
  description = "Whether the scheduled query alert rule is enabled"
  type        = bool
  default     = true
}

variable "query" {
  description = "The KQL query string to evaluate"
  type        = string
}

variable "severity" {
  description = "Severity of the alert (0, 1, 2, 3, 4)"
  type        = number
  default     = 1
}

variable "frequency" {
  description = "Frequency of evaluation in minutes (5, 10, 15, 30, 45, 60)"
  type        = number
  default     = 5
}

variable "time_window" {
  description = "Time window in minutes for data evaluation. Must be between 5 and 2880 and greater than or equal to frequency."
  type        = number
  default     = 30
}

variable "authorized_resource_ids" {
  description = "List of authorized resource IDs for cross-resource queries"
  type        = list(string)
  default     = []
}

variable "trigger_operator" {
  description = "Operator for the alert rule trigger (GreaterThan, LessThan, Equal, GreaterThanOrEqual, LessThanOrEqual)"
  type        = string
  default     = "GreaterThan"
}

variable "trigger_threshold" {
  description = "Alert rule trigger threshold value"
  type        = number
  default     = 0
}

variable "action_group_ids" {
  description = "List of action group resource IDs to associate with the alert"
  type        = list(string)
  default     = []
}

variable "email_subject" {
  description = "Email subject for alert notifications"
  type        = string
  default     = "Alert Notification"
}

variable "custom_webhook_payload" {
  description = "Custom webhook payload JSON string"
  type        = string
  default     = "{}"

  validation {
    condition     = can(jsondecode(var.custom_webhook_payload))
    error_message = "custom_webhook_payload must be a valid JSON string."
  }
}

variable "tags" {
  description = "Tags to apply to the alert rule"
  type        = map(string)
  default     = {}
}
