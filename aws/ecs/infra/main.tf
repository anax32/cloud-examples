module "vpc" {
  source = "./modules/vpc"

  project_name = var.project_name
  project_tags = var.project_tags
  network_tags = var.network_tags
  env          = var.env
}

module "fargate" {
  source = "./modules/fargate"

  project_name = var.project_name
  project_tags = var.project_tags
  network_tags = var.network_tags
  env          = var.env

  services = {
    db_service = {
      lb_target_group_arn = ""
      container_name = "mongo"
      container_port = 27017
      subnets = module.vpc.private_subnets
      security_groups = [""]
      public_ip = false
      service_tags = { type = "db" }
    }

    api_service = {
      lb_target_group_arn = ""
      container_name = "api"
      container_port = 8000
      subnets = module.vpc.public_subnets
      security_groups = [""]
      public_ip = true
      service_tags = { type = "api" }
    }
  }

  task_definitions = {
    db_service = {
      fargate_cpu = 200
      fargate_mem = 512
      container_definitions = jsonencode([])
      task_tags = { task = "db_service" }
    }

    api_service = {
      fargate_cpu = 120
      fargate_mem = 128
      container_definitions = jsonencode([])
      task_tags = { task = "api_service" }
    }
  }

  vpc_id = module.vpc.id

  certificate_arn = ""
}
