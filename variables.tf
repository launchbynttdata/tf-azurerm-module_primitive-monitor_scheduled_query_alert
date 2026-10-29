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

variable "scope_id" {
  description = <<-EOT
    Resource ID the rule is scoped to and whose logs the query runs against - a Log Analytics workspace,
    an Application Insights component, or any resource that sends logs to one. The Azure API accepts
    exactly one scope per rule. Changing this forces a new resource to be created.
  EOT
  type        = string
}

variable "description" {
  description = "Description of the scheduled query alert"
  type        = string
  default     = ""
}

variable "display_name" {
  description = "Display name of the alert rule. Left unset when null, in which case Azure's own display behaviour applies."
  type        = string
  default     = null
}

variable "enabled" {
  description = "Whether the scheduled query alert rule is enabled"
  type        = bool
  default     = true
}

variable "severity" {
  description = "Severity of the alert (0, 1, 2, 3, 4). 0 is the most severe."
  type        = number
  default     = 1
}

variable "evaluation_frequency" {
  description = <<-EOT
    How often the rule is evaluated, in ISO 8601 duration format. One of PT1M, PT5M, PT10M, PT15M, PT30M,
    PT45M, PT1H, PT2H, PT3H, PT4H, PT5H, PT6H, P1D. Cannot exceed window_duration *
    criteria.failing_periods.number_of_evaluation_periods, nor mute_actions_after_alert_duration.
  EOT
  type        = string
  default     = "PT5M"
}

variable "window_duration" {
  description = <<-EOT
    Period of logs each evaluation looks at (bin size), in ISO 8601 duration format. One of PT1M, PT5M,
    PT10M, PT15M, PT30M, PT45M, PT1H, PT2H, PT3H, PT4H, PT5H, PT6H, P1D, P2D. PT1M is only valid when
    evaluation_frequency is PT1M.
  EOT
  type        = string
  default     = "PT30M"
}

variable "criteria" {
  description = <<-EOT
    The condition the rule evaluates.

    query:                   KQL query to run against the scope. Validated by Azure on create unless
                             skip_query_validation is true.
    operator:                How threshold is compared. One of Equal, GreaterThan, GreaterThanOrEqual,
                             LessThan, LessThanOrEqual.
    threshold:               Value that activates the alert.
    time_aggregation_method: What is measured. Count measures the number of rows the query returns;
                             Average, Maximum, Minimum and Total aggregate metric_measure_column.
    metric_measure_column:   Column holding the number to aggregate. Required unless
                             time_aggregation_method is Count, and forbidden when it is.
    resource_id_column:      Column holding a resource ID, so fired alerts attribute to that resource.
    dimensions:              Columns to split the evaluation by. Azure evaluates the threshold separately
                             for each value and fires one alert per value, so the query must project each
                             dimension column. Use ["*"] to match every value.
    failing_periods:         How many of the last N evaluations must breach before the alert fires.
                             Omit it to leave the default to Azure. Both fields accept 1 to 6, and
                             number_of_evaluation_periods must be 1 for queries that do not project a
                             timestamp column.
  EOT

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

  validation {
    condition = (
      var.criteria.time_aggregation_method == "Count"
      ? var.criteria.metric_measure_column == null
      : var.criteria.metric_measure_column != null
    )
    error_message = "criteria.metric_measure_column is required unless criteria.time_aggregation_method is Count, and must be null when it is."
  }

  validation {
    condition = (
      var.criteria.failing_periods == null ||
      try(var.criteria.failing_periods.minimum_failing_periods_to_trigger_alert <= var.criteria.failing_periods.number_of_evaluation_periods, false)
    )
    error_message = "criteria.failing_periods.minimum_failing_periods_to_trigger_alert must be less than or equal to number_of_evaluation_periods."
  }
}

variable "action_group_ids" {
  description = "List of action group resource IDs to invoke when the alert fires"
  type        = list(string)
  default     = []
}

variable "custom_properties" {
  description = "Properties to add to the alert payload. Replaces the v1 custom_webhook_payload JSON string."
  type        = map(string)
  default     = {}
}

variable "email_subject" {
  description = "Subject override for emails sent by the action groups. Azure's default subject is used when unset."
  type        = string
  default     = null
}

variable "auto_mitigation_enabled" {
  description = <<-EOT
    Whether Azure resolves the alert on its own once the condition clears. When false the alert never
    resolves, so consumers that branch on monitorCondition never see a resolved notification. Mutually
    exclusive with mute_actions_after_alert_duration.
  EOT
  type        = bool
  default     = false
}

variable "mute_actions_after_alert_duration" {
  description = <<-EOT
    How long actions stay muted after the alert fires, in ISO 8601 duration format. One of PT5M, PT10M,
    PT15M, PT30M, PT45M, PT1H, PT2H, PT3H, PT4H, PT5H, PT6H, P1D, P2D. Set this to re-notify on a fixed
    cadence while a condition persists; requires auto_mitigation_enabled to be false.
  EOT
  type        = string
  default     = null
}

variable "query_time_range_override" {
  description = <<-EOT
    Query time range, when it should differ from window_duration *
    criteria.failing_periods.number_of_evaluation_periods. One of PT5M, PT10M, PT15M, PT20M, PT30M, PT45M,
    PT1H, PT2H, PT3H, PT4H, PT5H, PT6H, P1D, P2D, and cannot be less than that product.
  EOT
  type        = string
  default     = null
}

variable "skip_query_validation" {
  description = "Skip Azure's validation of criteria.query. Needed when the query references tables that do not exist in the scope yet."
  type        = bool
  default     = false
}

variable "target_resource_types" {
  description = <<-EOT
    Resource types within the scope to fire separate alerts for, e.g. Microsoft.Compute/virtualMachines
    when the scope is a resource group.
  EOT
  type        = list(string)
  default     = []
}

variable "workspace_alerts_storage_enabled" {
  description = "Whether the rule checks that alert storage is configured in the customer's own storage account"
  type        = bool
  default     = false
}

variable "identity" {
  description = <<-EOT
    Managed identity the rule queries as. Replaces the v1 authorized_resource_ids input: grant this
    identity Reader on every resource a cross-resource query reads.

    type:         SystemAssigned or UserAssigned.
    identity_ids: User assigned identity IDs. Required when type is UserAssigned, and must be empty
                  for SystemAssigned.
  EOT

  type = object({
    type         = string
    identity_ids = optional(list(string), [])
  })
  default = null

  validation {
    condition     = var.identity == null || try(var.identity.type != "UserAssigned" || length(var.identity.identity_ids) > 0, false)
    error_message = "identity.identity_ids is required when identity.type is UserAssigned."
  }

  # The provider rejects this inside the identity expand, which only runs on apply.
  validation {
    condition     = var.identity == null || try(var.identity.type == "UserAssigned" || length(var.identity.identity_ids) == 0, false)
    error_message = "identity.identity_ids must be empty when identity.type is SystemAssigned."
  }
}

variable "tags" {
  description = "Tags to apply to the alert rule"
  type        = map(string)
  default     = {}
}
