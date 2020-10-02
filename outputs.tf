output "autoscaling_group" {
  value       = aws_autoscaling_group.instance
  description = "Auto scaling group for the instance."
}

output "security_group" {
  value = aws_security_group.security_group
  description = "Auto scaling group's security group."
}
