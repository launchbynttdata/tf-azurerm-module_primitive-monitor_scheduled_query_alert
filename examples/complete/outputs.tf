output "scheduled_query_alert_id" {
  description = "The ID of the scheduled query alert"
  value       = module.scheduled_query_alert.scheduled_query_alert_id
}

output "scheduled_query_alert_name" {
  description = "The name of the scheduled query alert"
  value       = module.scheduled_query_alert.scheduled_query_alert_name
}

output "log_analytics_workspace_id" {
  description = "The ID of the Log Analytics Workspace"
  value       = module.log_analytics_workspace.id
}

output "application_insights_id" {
  description = "The ID of the Application Insights component the rule is scoped to"
  value       = module.application_insights.id
}

output "monitor_action_group_id" {
  description = "The ID of the action group the alert invokes"
  value       = module.monitor_action_group.action_group_id
}

output "resource_group_name" {
  description = "The name of the resource group"
  value       = module.resource_group.name
}
