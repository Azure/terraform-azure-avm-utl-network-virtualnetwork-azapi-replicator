# Post-operation outputs (add as needed by Type 5 tasks)
# output "post_creation0" { value = local.post_creation0 }
# output "post_creation0_sensitive_body" { value = local.post_creation0_sensitive_body; sensitive = true }
# output "post_update1" { value = local.post_update1 }
# output "post_update1_sensitive_body" { value = local.post_update1_sensitive_body; sensitive = true }
# output "post_update2" { value = local.post_update2 }
# output "post_update2_sensitive_body" { value = local.post_update2_sensitive_body; sensitive = true }
output "azapi_header" {
  depends_on = []
  value      = local.azapi_header
}

output "body" {
  value = local.body
}

output "locks" {
  value = local.locks
}

output "replace_triggers_external_values" {
  value = local.replace_triggers_external_values
}

output "retry" {
  value = local.retry
}

output "sensitive_body" {
  ephemeral = true
  sensitive = true
  value     = local.sensitive_body
}

output "sensitive_body_version" {
  value = local.sensitive_body_version
}

output "timeouts" {
  value = var.timeouts
}
