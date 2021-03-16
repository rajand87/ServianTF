
module "alb" {
  source  = "terraform-aws-modules/alb/aws"
  version = "~> 5.0"

  name = "ec2-alb"

  load_balancer_type = "application"

  vpc_id             = module.vpc.vpc_id
  subnets            = module.vpc.public_subnets
  security_groups    = [aws_security_group.elk.id]


  target_groups = [{
      name_prefix      = "Target"
      backend_protocol = "HTTP"
      backend_port     = 80
      target_type      = "instance"
    }]


  http_tcp_listeners = [
    {
      port               = 80
      protocol           = "HTTP"
      target_group_index = 0
    }
  ]

  tags = {
    Environment = "servian"
  }

    depends_on = [
    module.ec2_cluster
  ]

}

resource "aws_autoscaling_attachment" "ec2alb2target" {
  autoscaling_group_name = aws_autoscaling_group.ec2asg.id
  alb_target_group_arn   = module.alb.target_group_arns[0]
  depends_on = [
    aws_autoscaling_group.ec2asg, module.alb
  ]
}

output "alb_dns" {
  value = module.alb.this_lb_dns_name
}
