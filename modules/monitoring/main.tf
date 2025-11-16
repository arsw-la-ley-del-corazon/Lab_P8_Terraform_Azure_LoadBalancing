resource "azurerm_log_analytics_workspace" "law" {
  name                = "${var.prefix}-law"
  location            = var.location
  resource_group_name = var.resource_group_name
  sku                 = "PerGB2018"
  retention_in_days   = 30

  tags = var.tags
}

resource "azurerm_monitor_action_group" "email" {
  name                = "${var.prefix}-ag"
  resource_group_name = var.resource_group_name
  short_name          = "ag"
  location            = "global"

  email_receiver {
    name                    = "emailReceiver"
    email_address           = "jeisson.sanchez-g@mail.escuelaing.edu.co"
    use_common_alert_schema = true
  }

  tags = var.tags
}

resource "azurerm_monitor_metric_alert" "cpu_alert" {
  name                = "${var.prefix}-vm-cpu-high"
  resource_group_name = var.resource_group_name
  scopes = var.vm_ids
  target_resource_type     = "Microsoft.Compute/virtualMachines"
  target_resource_location = var.location
  description = "CPU over 80%"
  severity    = 2
  enabled     = true

  frequency   = "PT1M"
  window_size = "PT5M"
  auto_mitigate = true

  criteria {
    metric_namespace       = "Microsoft.Compute/virtualMachines"
    metric_name            = "Percentage CPU"
    aggregation            = "Average"
    operator               = "GreaterThan"
    threshold              = 80
    skip_metric_validation = false
  }

  action {
    action_group_id = azurerm_monitor_action_group.email.id
  }

  tags = var.tags
}
