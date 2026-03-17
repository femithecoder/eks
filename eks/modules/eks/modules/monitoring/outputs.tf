output "loki_bucket_name" {
  value = aws_s3_bucket.loki_logs.bucket
}

output "grafana_admin_password" {
  value     = local.grafana_admin_password
  sensitive = true
}
