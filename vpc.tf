module "vpc" {
  source = "terraform-aws-modules/vpc/aws"

  name = "myvpc"
  cidr = "10.0.4.0/24"

  azs             = ["us-east-2a","us-east-2b"]
  public_subnets = ["10.0.4.0/28","10.0.4.16/28"]
  
  create_igw = true
  create_database_subnet_group = true
  enable_dns_hostnames = true

  tags = {
    Terraform = "true"
    Environment = "Servian"
  }
}



