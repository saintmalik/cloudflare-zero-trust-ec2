# ==============================================================================
# AMI
# ==============================================================================
data "aws_ami" "amazon_linux_2023" {
  most_recent = true

  filter {
    name   = "owner-alias"
    values = ["amazon"]
  }

  filter {
    name   = "name"
    values = ["al2023-ami-2023*"]
  }

  filter {
    name   = "root-device-type"
    values = ["ebs"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  filter {
    name   = "architecture"
    values = ["x86_64"]
  }
}

resource "aws_instance" "ec2" {
  ami           = data.aws_ami.amazon_linux_2023.id
  instance_type = var.instance_type

  subnet_id              = aws_subnet.private.id
  vpc_security_group_ids = [aws_security_group.private_sg.id]

  iam_instance_profile        = aws_iam_instance_profile.instance_profile.name
  user_data                   = local.instance_values
  user_data_replace_on_change = true
  metadata_options {
    http_endpoint = "enabled"
    http_tokens   = "required"
  }

  tags = merge(
    local.common_tags,
    {
      Name = "internalwebapp-ec2-instance"
    }
  )
}

resource "aws_ec2_instance_state" "ec2" {
  instance_id = aws_instance.ec2.id
  state       = var.instance_state
}
