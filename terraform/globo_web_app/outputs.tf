output "dns_name" {
  value = aws_instance.nginx1.public_dns
  description = "DNS hostname of EC2"
}