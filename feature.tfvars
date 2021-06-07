enabled = true

region = "us-east-2"

namespace = "mattermost"

stage = "dev"

//name = "mattermost"

availability_zones = ["ap-southeast-1a", "ap-southeast-1b"]

assign_eip_address = false

associate_public_ip_address = true

instance_type = "t3.micro"

security_group_rules = [
  {
    type        = "egress"
    from_port   = 0
    to_port     = 65535
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  },
  {
    type        = "ingress"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  },
  {
    type        = "ingress"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  },
  {
    type        = "ingress"
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  },
  {
    type        = "ingress"
    from_port   = 53
    to_port     = 53
    protocol    = "udp"
    cidr_blocks = ["0.0.0.0/0"]
  },
]

ssh_public_key_path = "/Users/apple/PROJECT/16_inter_servers/te-aws-center/internal_apps/demo"

multi_az = false

database_name = "mattermost"

database_user = "mattermost"

database_password = "mattermost"

database_port = 5432

apply_immediately = true

storage_type = "standard"

allocated_storage = 5

storage_encrypted = false

engine = "postgres"

engine_version = "13.2"

major_engine_version = "13.2"

instance_class = "db.t3.small"

db_parameter_group = "postgres13"

publicly_accessible = false

