output "public_ip" {
  description = "Public IP of instance (or EIP)"
  value       = module.ec2_instance.public_ip
}
output "instance_id" {
  value       = module.rds_instance.instance_id
  description = "ID of the instance"
}
output "instance_address" {
  value       = module.rds_instance.instance_address
  description = "Address of the instance"
}

output "instance_endpoint" {
  value       = module.rds_instance.instance_endpoint
  description = "DNS Endpoint of the instance"
}
