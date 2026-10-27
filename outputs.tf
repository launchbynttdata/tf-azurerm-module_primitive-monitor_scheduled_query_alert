output "scheduled_query_alert_id" {
  description = "The ID of the scheduled query alert rule"
  value       = azurerm_monitor_scheduled_query_rules_alert_v2.scheduled_query_alert.id
}

output "scheduled_query_alert_name" {
  description = "The name of the scheduled query alert rule"
  value       = azurerm_monitor_scheduled_query_rules_alert_v2.scheduled_query_alert.name
}

output "scheduled_query_alert_principal_id" {
  description = "Principal ID of the rule's managed identity, for granting it read access to the resources its query reads. Null when no identity is configured."
  value       = try(azurerm_monitor_scheduled_query_rules_alert_v2.scheduled_query_alert.identity[0].principal_id, null)
}
