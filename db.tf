module "db" {
    source  = "terraform-aws-modules/rds/aws"

  identifier = "serviandb"
  engine               = "postgres"
  engine_version       = "11.10"
  instance_class       = "db.t2.micro"
  family               = "postgres11"
  major_engine_version = "11"

  allocated_storage     = 20
  storage_encrypted     = false

  name     = "postgres"
  username = "postgres"
  password = "Abcde123"
  port     = 5432

  subnet_ids             = module.vpc.public_subnets
  vpc_security_group_ids = [module.security_group.this_security_group_id]



  backup_retention_period = 0
  skip_final_snapshot     = true
  deletion_protection     = false

  maintenance_window              = "Mon:00:00-Mon:03:00"
  backup_window                   = "03:00-06:00"
  
  tags = {
    Terraform = "true"
    Environment = "Servian"
  }
  
  create_db_option_group    = false
  create_db_parameter_group = false
}

