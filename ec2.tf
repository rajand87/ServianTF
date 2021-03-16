data "template_file" "client" {
  template = file("./build.sh")

  depends_on = [
    module.db
  ]
}

data "template_cloudinit_config" "config" {
  gzip          = false
  base64_encode = false

    part {
    content_type = "text/x-shellscript"
    content      = data.template_file.client.rendered
  }

  part {
    content_type = "text/x-shellscript"
    content      = <<-EOF
    #!/bin/bash
    set -ex
    cd /raja/TechChallengeApp
    pwd
    echo '"DbHost" = "${trimsuffix(module.db.this_db_instance_endpoint, ":5432")}"' >> /raja/TechChallengeApp/conf.toml
    docker build -t rajanaidu356/gotodolist:latest .
    docker push rajanaidu356/gotodolist:latest
    docker run rajanaidu356/gotodolist:latest updatedb
    EOF
  }

  depends_on = [
    module.db
  ]

}

module "ec2_cluster" {
  source                 = "terraform-aws-modules/ec2-instance/aws"
  version                = "~> 2.0"

  name                   = "go_instance"
  instance_count         = 1

  ami                    = "ami-0996d3051b72b5b2c"
  instance_type          = "t2.micro"
  key_name               = var.key
  monitoring             = false
  vpc_security_group_ids = [aws_security_group.elk.id]
  subnet_id              = module.vpc.public_subnets[0]
  user_data = data.template_cloudinit_config.config.rendered

  tags = {
    Terraform   = "true"
    Environment = "servian"
  }

    depends_on = [
    module.db
  ]
}







