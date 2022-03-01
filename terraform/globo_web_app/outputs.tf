output "dns_name_nginx_instance_1" {
  value = aws_instance.nginx-instance-1.public_dns
  description = "DNS hostname of EC2 #1"
}

output "dns_name_nginx_instance_2" {
  value = aws_instance.nginx-instance-2.public_dns
  description = "DNS hostname of EC2 #2"
}