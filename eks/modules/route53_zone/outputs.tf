output "arn" {
  value = aws_route53_zone.dns_zone.arn
}
output "name_servers" {
  value = aws_route53_zone.dns_zone.name_servers
}
output "zone_id" {
  value = aws_route53_zone.dns_zone.zone_id
}
output "domain_name" {
  value = aws_route53_zone.dns_zone.name
}