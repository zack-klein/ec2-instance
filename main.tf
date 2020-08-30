resource "aws_key_pair" "key" {
  key_name   = var.instance_name
  public_key = var.ssh_public_key
}

resource "aws_security_group" "security_group" {
  name        = "${var.instance_name}-traffic"
  description = "Allow traffic from SSH and the internet."
  vpc_id      = var.vpc_id

  ingress {
    description = "HTTPS traffic."
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = local.https-cidr
  }

  ingress {
    description = "HTTP traffic."
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = local.https-cidr
  }

  ingress {
    description = "SSH from workstation"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = local.ssh-cidr
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "allow_tls"
  }
}

resource "aws_launch_configuration" "instance" {
  name_prefix          = "${var.instance_name}-"
  image_id             = var.ami
  instance_type        = var.instance_type
  iam_instance_profile = var.instance_profile
  key_name             = aws_key_pair.key.key_name
  user_data            = file(var.user_data_path)
  security_groups      = [aws_security_group.security_group.id]

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_autoscaling_group" "instance" {
  name                 = var.instance_name
  launch_configuration = aws_launch_configuration.instance.name
  min_size             = var.min_size
  max_size             = var.max_size
  vpc_zone_identifier  = var.subnets
  lifecycle {
    create_before_destroy = true
  }
  tag {
    key                 = "Name"
    value               = var.instance_name
    propagate_at_launch = true
  }

  tag {
    key                 = "Public"
    value               = var.public
    propagate_at_launch = true
  }
}
