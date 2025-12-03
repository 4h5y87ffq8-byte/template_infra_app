# Development Environment Configuration
environment = "dev"
aws_region  = "us-east-1"

# Project
project_name   = "template-app"
repository_url = "https://github.com/yourorg/template_infra_app"

# Networking
vpc_cidr              = "10.0.0.0/16"
availability_zones    = ["us-east-1a", "us-east-1b"]
public_subnet_cidrs   = ["10.0.1.0/24", "10.0.2.0/24"]
private_subnet_cidrs  = ["10.0.11.0/24", "10.0.12.0/24"]

# ECS
ecs_cluster_name = "app-cluster-dev"
ecs_task_cpu     = "256"
ecs_task_memory  = "512"
app_port         = 8080
app_count        = 1

# RDS
db_instance_class     = "db.t3.micro"
db_name               = "appdb"
db_username           = "admin"
db_allocated_storage  = 20

# ElastiCache
redis_node_type       = "cache.t3.micro"
redis_num_cache_nodes = 1

# ALB
alb_internal = false

# Auto Scaling
min_capacity  = 1
max_capacity  = 2
cpu_threshold = 70

# Tags
additional_tags = {
  Team        = "Platform"
  CostCenter  = "Engineering"
}
