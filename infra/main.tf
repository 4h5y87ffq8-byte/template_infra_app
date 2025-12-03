# ===== VPC Module =====
module "vpc" {
  source = "./modules/vpc"

  name_prefix            = local.name_prefix
  vpc_cidr              = var.vpc_cidr
  availability_zones    = var.availability_zones
  public_subnet_cidrs   = var.public_subnet_cidrs
  private_subnet_cidrs  = var.private_subnet_cidrs
  
  tags = local.common_tags
}

# ===== ECS Cluster =====
module "ecs" {
  source = "./modules/ecs"

  name_prefix      = local.name_prefix
  cluster_name     = var.ecs_cluster_name
  vpc_id           = module.vpc.vpc_id
  private_subnets  = module.vpc.private_subnet_ids
  public_subnets   = module.vpc.public_subnet_ids
  
  # Task definition
  task_cpu         = var.ecs_task_cpu
  task_memory      = var.ecs_task_memory
  app_port         = var.app_port
  app_count        = var.app_count
  
  # Environment variables for the application
  environment_variables = [
    {
      name  = "SPRING_PROFILES_ACTIVE"
      value = var.environment
    },
    {
      name  = "SPRING_DATASOURCE_URL"
      value = "jdbc:postgresql://${module.rds.db_endpoint}/${var.db_name}"
    },
    {
      name  = "SPRING_REDIS_HOST"
      value = module.elasticache.redis_endpoint
    },
    {
      name  = "SPRING_REDIS_PORT"
      value = tostring(local.redis_port)
    }
  ]
  
  # Secrets from AWS Secrets Manager
  secrets = [
    {
      name      = "SPRING_DATASOURCE_USERNAME"
      valueFrom = module.rds.db_credentials_secret_arn
    },
    {
      name      = "SPRING_DATASOURCE_PASSWORD"
      valueFrom = module.rds.db_credentials_secret_arn
    }
  ]
  
  # Auto scaling
  min_capacity   = var.min_capacity
  max_capacity   = var.max_capacity
  cpu_threshold  = var.cpu_threshold
  
  # ALB
  alb_security_group_id = module.alb.security_group_id
  target_group_arn      = module.alb.target_group_arn
  
  tags = local.common_tags
}

# ===== Application Load Balancer =====
module "alb" {
  source = "./modules/alb"

  name_prefix         = local.name_prefix
  vpc_id              = module.vpc.vpc_id
  public_subnets      = module.vpc.public_subnet_ids
  internal            = var.alb_internal
  ssl_certificate_arn = var.ssl_certificate_arn
  app_port            = var.app_port
  
  tags = local.common_tags
}

# ===== RDS PostgreSQL =====
module "rds" {
  source = "./modules/rds"

  name_prefix         = local.name_prefix
  vpc_id              = module.vpc.vpc_id
  private_subnets     = module.vpc.private_subnet_ids
  
  instance_class      = var.db_instance_class
  allocated_storage   = var.db_allocated_storage
  db_name             = var.db_name
  db_username         = var.db_username
  
  # Security group rules
  allowed_security_groups = [module.ecs.security_group_id]
  
  tags = local.common_tags
}

# ===== ElastiCache Redis =====
module "elasticache" {
  source = "./modules/elasticache"

  name_prefix      = local.name_prefix
  vpc_id           = module.vpc.vpc_id
  private_subnets  = module.vpc.private_subnet_ids
  
  node_type        = var.redis_node_type
  num_cache_nodes  = var.redis_num_cache_nodes
  
  # Security group rules
  allowed_security_groups = [module.ecs.security_group_id]
  
  tags = local.common_tags
}

# ===== CloudWatch Logs =====
resource "aws_cloudwatch_log_group" "app" {
  name              = "/aws/ecs/${local.name_prefix}"
  retention_in_days = 30
  
  tags = local.common_tags
}

# ===== ECR Repository =====
resource "aws_ecr_repository" "app" {
  name                 = local.name_prefix
  image_tag_mutability = "MUTABLE"

  image_scanning_configuration {
    scan_on_push = true
  }
  
  tags = local.common_tags
}

resource "aws_ecr_lifecycle_policy" "app" {
  repository = aws_ecr_repository.app.name

  policy = jsonencode({
    rules = [
      {
        rulePriority = 1
        description  = "Keep last 10 images"
        selection = {
          tagStatus     = "tagged"
          tagPrefixList = ["v"]
          countType     = "imageCountMoreThan"
          countNumber   = 10
        }
        action = {
          type = "expire"
        }
      },
      {
        rulePriority = 2
        description  = "Remove untagged images after 7 days"
        selection = {
          tagStatus   = "untagged"
          countType   = "sinceImagePushed"
          countUnit   = "days"
          countNumber = 7
        }
        action = {
          type = "expire"
        }
      }
    ]
  })
}
