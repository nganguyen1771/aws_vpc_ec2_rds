provider "aws" {
  region  = "ap-southeast-1"
  shared_credentials_file = "~/.aws/session_token"
//  dev
  assume_role {
    role_arn = "arn:aws:iam::<deploy_account>:role/infras_admin"
  }
  version = "~> 2.11"

}

terraform {
  required_version = ">= 0.12.0"

  backend "s3" {
    bucket  = "internal-apps-tfstate"
    region  = "ap-southeast-1"
    profile = "te-gateway"
    key     = "apps.tfstate.aws"
    encrypt = true
  }
}

module "vpc" {
  source  = "cloudposse/vpc/aws"
  version = "0.18.2"

  cidr_block = "172.16.0.0/16"
//generate consistent names and tags for resources
//{namespace}-{environment}-{stage}-{name}-{attributes}
  context = module.this.context
}

module "subnets" {
  source  = "cloudposse/dynamic-subnets/aws"
  version = "0.34.0"

  availability_zones   = var.availability_zones
  vpc_id               = module.vpc.vpc_id
  igw_id               = module.vpc.igw_id
  cidr_block           = module.vpc.vpc_cidr_block
  nat_gateway_enabled  = false
  nat_instance_enabled = false

  context = module.this.context
}
module "aws_key_pair" {
  source              = "cloudposse/key-pair/aws"
  version             = "0.16.1"
  ssh_public_key_path = var.ssh_public_key_path
  generate_ssh_key    = true

  context = module.this.context
}

data "aws_iam_policy_document" "test" {
  statement {
    effect = "Allow"

    actions = [
      "sts:AssumeRole"
    ]

    principals {
      type        = "Service"
      identifiers = ["ec2.amazonaws.com"]
    }
  }
}

module "instance_profile_label" {
  source  = "cloudposse/label/null"
  version = "0.22.1"

  attributes = distinct(compact(concat(module.this.attributes, ["profile"])))

  context = module.this.context
}

resource "aws_iam_role" "test" {
  name               = module.instance_profile_label.id
  assume_role_policy = data.aws_iam_policy_document.test.json
  tags               = module.instance_profile_label.tags
}

# https://github.com/hashicorp/terraform-guides/tree/master/infrastructure-as-code/terraform-0.13-examples/module-depends-on
resource "aws_iam_instance_profile" "test" {
  name = module.instance_profile_label.id
  role = aws_iam_role.test.name
}

module "ec2_instance" {
  source = "cloudposse/ec2-instance/aws"

  ssh_key_pair                = module.aws_key_pair.key_name
  vpc_id                      = module.vpc.vpc_id
  subnet                      = module.subnets.public_subnet_ids[0]
  security_groups             = [module.vpc.vpc_default_security_group_id]
  assign_eip_address          = var.assign_eip_address
  associate_public_ip_address = var.associate_public_ip_address
  instance_type               = var.instance_type
  security_group_rules        = var.security_group_rules
  instance_profile            = aws_iam_instance_profile.test.name
  context = module.this.context
  name = "ec2"
  
}

module "rds_instance" {
  source               = "cloudposse/rds/aws"
  database_name        = var.database_name
  database_user        = var.database_user
  database_password    = var.database_password
  database_port        = var.database_port
  multi_az             = var.multi_az
  storage_type         = var.storage_type
  allocated_storage    = var.allocated_storage
  storage_encrypted    = var.storage_encrypted
  engine               = var.engine
  engine_version       = var.engine_version
  instance_class       = var.instance_class
  db_parameter_group   = var.db_parameter_group
  publicly_accessible  = var.publicly_accessible
  vpc_id               = module.vpc.vpc_id
  subnet_ids           = module.subnets.private_subnet_ids
  security_group_ids   = [module.vpc.vpc_default_security_group_id]
  apply_immediately    = var.apply_immediately
  availability_zone    = var.availability_zones[0]
  db_subnet_group_name = var.db_subnet_group_name
  name = "rds"
  context = module.this.context
}

