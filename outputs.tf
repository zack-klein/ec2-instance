output "autoscaling_group" {
  value       = aws_autoscaling_group.instance
  description = "Auto scaling group for the instance."
}
