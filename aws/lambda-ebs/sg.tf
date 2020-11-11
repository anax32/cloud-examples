module "public_sg" {
  source  = "terraform-aws-modules/security-group/aws"
  version = "3.16.0"

  name        = "${var.project_name}-sg"
  vpc_id      = module.vpc.vpc_id

  ingress_cidr_blocks = module.vpc.public_subnets_cidr_blocks
  ingress_rules = ["http-80-tcp"]

  egress_cidr_blocks = ["0.0.0.0/0"]
  egress_rules = ["all-all"]

  tags = merge(var.project_tags, var.network_tags)
}


data "aws_vpc_endpoint" "s3" {
  vpc_id       = module.vpc.vpc_id
}

module "lambda_efs_sg" {
  source  = "terraform-aws-modules/security-group/aws"
  version = "3.16.0"

  name        = "${var.project_name}-sg"
  vpc_id      = module.vpc.vpc_id

  ingress_with_cidr_blocks = [
    {
      from_port   = 2049
      to_port     = 2049
      protocol    = "TCP"
      description = "efs_ingress"
      cidr_blocks = aws_subnet.efs.cidr_block
    }
  ]

  egress_with_cidr_blocks = [
    {
      from_port = 2049
      to_port = 2049
      protocol = "TCP"
      cidr_blocks = aws_subnet.efs.cidr_block
    },
    {
      from_port = 443
      to_port = 443
      protocol = "TCP"
      cidr_blocks = join(",", data.aws_vpc_endpoint.s3.cidr_blocks)
    }
  ]

  tags = merge(var.project_tags, var.network_tags)
}
