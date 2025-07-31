resource "aws_instance" "ec2_instance" {
  for_each      = { for idx, instance in var.instances : idx => instance }
  ami           = each.value.ami_id
  instance_type = each.value.instance_type
  key_name      = var.key_names[each.key]

  subnet_id = (
    each.value.subnet_type == "public" ?
    element(var.public_subnet_ids[each.value.vpc_key], each.value.subnet_index) :
    element(var.private_subnet_ids[each.value.vpc_key], each.value.subnet_index)
  )

  root_block_device {
    volume_type           = each.value.ebs_volume_type
    volume_size           = each.value.ebs_volume_size
    delete_on_termination = true
    encrypted             = true
    kms_key_id            = var.kms_key_id
  }
  dynamic "ebs_block_device" {
    for_each = each.value.secondary_ebs_volume_type != null && each.value.secondary_ebs_volume_size != null ? [each.value] : []
    content {
      device_name           = each.value.os_type == "windows" ? "xvdf" : "/dev/sdf"
      volume_type           = ebs_block_device.value.secondary_ebs_volume_type
      volume_size           = ebs_block_device.value.secondary_ebs_volume_size
      delete_on_termination = true
      encrypted             = true
      kms_key_id            = var.kms_key_id
    }
  }

  vpc_security_group_ids = [
    var.security_groups[each.value.security_group_name]
  ]

  tags = {
    Name = each.value.name
  }
}

resource "aws_eip" "elastic_ip" {
  for_each = {
  for idx, instance in var.instances : idx => instance
  if coalesce(instance.associate_eip, false)
  }

  instance = aws_instance.ec2_instance[each.key].id
  tags = {
    Name = "${each.value.name}-EIP"
  }
}