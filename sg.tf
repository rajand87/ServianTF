resource "aws_security_group" "elk" {
  name        = "Go"
  description = "Allow ELK inbound traffic"
  vpc_id      = module.vpc.vpc_id

  ingress {
    description = "custom TCP"
    from_port   = 0
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
    ingress {
    description = "SSH"
    from_port   = 0
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Environment = "Servian"
  }
}

module "security_group" {
  source  = "terraform-aws-modules/security-group/aws"
  version = "~> 3"

  name        = "rdspostgress"
  description = "PostgreSQL security group"
  vpc_id      = module.vpc.vpc_id

  # ingress
  ingress_with_cidr_blocks = [
    {
      from_port   = 5432
      to_port     = 5432
      protocol    = "tcp"
      description = "PostgreSQL access from within VPC"
      cidr_blocks = module.vpc.vpc_cidr_block
    },
  ]

    tags = {
    Terraform = "true"
    Environment = "Servian"
  }
}