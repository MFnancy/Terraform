# output "public_ip" {
#   description = "public address of my webserver"
#   value       = aws_instance.web.public_ip

# }

# output "private_ip" {
#   description = "private address of my webserver"
#   value       = aws_instance.web.private_ip
# }

output "alb_dns_name" {
  description = "loadbalancer domain name"
  value       = aws_lb.test.dns_name
}