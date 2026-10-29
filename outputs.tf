output "scheduled_query_alert_id" {
  description = "The ID of the scheduled query alert rule"
  value       = azurerm_monitor_scheduled_query_rules_alert_v2.scheduled_query_alert.id
}

output "scheduled_query_alert_name" {
  description = "The name of the scheduled query alert rule"
  value       = azurerm_monitor_scheduled_query_rules_alert_v2.scheduled_query_alert.name
}

output "scheduled_query_alert_principal_id" {
  description = "Principal ID of the rule's SystemAssigned identity, for granting it read access to the resources its query reads. Null when no identity is configured, and empty for UserAssigned - Azure exposes no principal on the rule in that case, so grant access to the user assigned identity's own principal instead."
  value       = try(azurerm_monitor_scheduled_query_rules_alert_v2.scheduled_query_alert.identity[0].principal_id, null)
}
