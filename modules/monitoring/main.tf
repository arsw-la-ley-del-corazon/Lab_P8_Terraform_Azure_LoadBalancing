resource "azurerm_log_analytics_workspace" "law" {
  name                = "${var.prefix}-law"
  location            = var.location
  resource_group_name = var.resource_group_name
  sku                 = "PerGB2018"
  retention_in_days   = 30
  tags                = var.tags
}

resource "azurerm_monitor_action_group" "email" {
  name                = "${var.prefix}-ag"
  resource_group_name = var.resource_group_name
  short_name          = "ag"

  email_receiver {
    name                    = "emailReceiver"
    email_address           = var.alert_email
    use_common_alert_schema = true
  }

  tags = var.tags
}

resource "azurerm_monitor_metric_alert" "cpu_alert" {
  name                = "${var.prefix}-vm-cpu-high"
  resource_group_name = var.resource_group_name
  scopes              = var.vm_ids

  description = "CPU over 80%"
  severity    = 2
  frequency   = "PT1M"
  window_size = "PT5M"

  criteria {
    metric_namespace  = "Microsoft.Compute/virtualMachines"
    metric_name       = "Percentage CPU"
    aggregation       = "Average"
    operator          = "GreaterThan"
    threshold         = 80
  }

  action {
    action_group_id = azurerm_monitor_action_group.email.id
  }

  tags = var.tags
}
