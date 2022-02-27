
output "instance_id" {
  description = "The EC2 instance ID"
  value       = "${aws_instance.vm.id}"
}

output "instance_public_dns" {
  description = "The EC2 instance public DNS"
  value       = "${aws_instance.vm.public_dns}"
}