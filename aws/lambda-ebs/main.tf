module "vpc" {
  source = "terraform-aws-modules/vpc/aws"

  name = "${var.project_name}-vpc"
  cidr = "10.0.0.0/16"

  azs             = ["eu-west-2a", "eu-west-2b"]
  intra_subnets   = ["10.0.1.0/24", "10.0.2.0/24"]
  public_subnets  = ["10.0.101.0/24", "10.0.102.0/24"]

  enable_nat_gateway = true
  enable_vpn_gateway = true
#  single_nat_gateway = true
#  one_nat_gateway_per_az = true
  enable_s3_endpoint = true

  tags = merge(var.project_tags)
}

# create a custom subnet for the efs mount points
resource "aws_subnet" "efs" {
  vpc_id            = module.vpc.vpc_id
  availability_zone = "eu-west-2a"
  cidr_block        = "10.0.3.0/24"
}
