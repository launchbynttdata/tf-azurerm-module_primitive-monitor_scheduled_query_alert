output "scheduled_query_alert_id" {
  description = "The ID of the scheduled query alert rule"
  value       = azurerm_monitor_scheduled_query_rules_alert.scheduled_query_alert.id
}

output "scheduled_query_alert_name" {
  description = "The name of the scheduled query alert rule"
  value       = azurerm_monitor_scheduled_query_rules_alert.scheduled_query_alert.name
}
