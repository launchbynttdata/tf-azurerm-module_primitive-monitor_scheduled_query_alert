output "scheduled_query_alert_id" {
  description = "The ID of the scheduled query alert"
  value       = module.scheduled_query_alert.scheduled_query_alert_id
}

output "scheduled_query_alert_name" {
  description = "The name of the scheduled query alert"
  value       = module.scheduled_query_alert.scheduled_query_alert_name
}

output "application_insights_id" {
  description = "The ID of the Application Insights instance"
  value       = module.application_insights.id
}

output "log_analytics_workspace_id" {
  description = "The ID of the Log Analytics Workspace"
  value       = module.log_analytics_workspace.id
}

output "monitor_action_group_id" {
  value = module.monitor_action_group.action_group_id
}
