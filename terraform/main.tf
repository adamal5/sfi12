provider "aws" {
  region  = "eu-west-2"
  version = "2.8"
  alias   = "aws-uk"
}

resource "aws_instance" "jenkins" {
  provider                 = "aws.aws-uk"
  ami                      = var.ami-uk
  instance_type            = var.type
  vpc_security_group_ids   = ["sg-03fc04a571396dc83"]
  key_name                 = "adamal5"
  tags = {
    Name = "Jenkins"
  }
}

resource "aws_instance" "test-environment" {
  provider      = "aws.aws-uk"
  ami           = var.ami-uk
  instance_type = var.type
  vpc_security_group_ids   = ["sg-03fc04a571396dc83"]
  key_name      = "adamal5"
  tags          = {
    Name = "test-environment"
  }
}


variable "ami-uk" {
  description = "machine image uk"
  default     = "ami-09a1e275e350acf38"
}

variable "type" {
  default = "t2.micro"
}



resource "local_file" "jenkins-variables" {
  content     = "test-file"
  filename    = "${path.module}/jenkins-variables.groovy"
}


resource "aws_db_instance" "production-db" {
  provider             = "aws.aws-uk"
  allocated_storage    = 20
  storage_type         = "gp2"
  engine               = "mysql"
  engine_version       = "5.7"
  instance_class       = "db.t2.micro"
  name                 = "users"
  username             = "admin"
  password             = "ab5gh78af"
  skip_final_snapshot  = true
  publicly_accessible  = true
  vpc_security_group_ids   = ["sg-03fc04a571396dc83"]
  iam_database_authentication_enabled = true
  domain_iam_role_name ="ac-rds-full-access"
}

resource "aws_db_instance" "test-db" {
  provider             = "aws.aws-uk" 
  allocated_storage    = 20 
  storage_type         = "gp2"
  engine               = "mysql"
  engine_version       = "5.7"
  instance_class       = "db.t2.micro"
  name                 = "test"
  username             = "admin"
  password             = "ab5gh78hj"
  skip_final_snapshot  = true
  publicly_accessible  = true
  vpc_security_group_ids   = ["sg-03fc04a571396dc83"]
  iam_database_authentication_enabled = true
  domain_iam_role_name ="ac-rds-full-access"
} 
