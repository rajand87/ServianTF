
data "template_cloudinit_config" "userdata" {
  gzip          = true
  base64_encode = true

  part {
    content_type = "text/x-shellscript"
    content      = <<-EOF
    #!/bin/bash
    set -ex
    sudo apt-get update
    sudo apt-get install docker -y
    sudo apt-get install docker-compose -y
    docker run -p 80:3000 "${var.image}" serve
    EOF
  }

}


resource "aws_launch_template" "ec2lt" {
  name = "TemplateForTodolist"

  disable_api_termination = true
  image_id = "ami-08962a4068733a2b6"
  instance_initiated_shutdown_behavior = "terminate"
  instance_type = "t2.micro"
  key_name = var.key

  placement {
    availability_zone = "us-east-2a"
  }

  vpc_security_group_ids = [aws_security_group.elk.id]


  tag_specifications {
    resource_type = "instance"
    tags = {
      Name = "TemplateForTodolist"
      Environment = "servian"
    }
  }
  user_data = data.template_cloudinit_config.userdata.rendered

  depends_on = [
    module.ec2_cluster
  ]
}


resource "aws_autoscaling_group" "ec2asg" {
  desired_capacity   = 1
  max_size           = 2
  min_size           = 1

  vpc_zone_identifier       = module.vpc.public_subnets

  launch_template {
    id      = aws_launch_template.ec2lt.id
  }

  tag {
    key = "Environment1"
    value = "servian"
    propagate_at_launch = true
  }


  instance_refresh {
    strategy = "Rolling"
    preferences {
      min_healthy_percentage = 50
    }
    triggers = ["tag"]
  }

  target_group_arns = module.alb.target_group_arns

  depends_on = [
    module.ec2_cluster, module.alb, aws_launch_template.ec2lt
  ]

}