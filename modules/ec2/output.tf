
output "instance_id" {
    value = aws_instance.ec2Instance.*.id
}
output "instance-ip" {
    value = aws_instance.ec2Instance.*.public_ip
}
output "keyname" {
    value = data.aws_key_pair.MyEC2Key.key_name
  
}
