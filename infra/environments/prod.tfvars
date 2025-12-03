# Production Environment Configuration
environment = "prod"
aws_region  = "us-east-1"

# Project
project_name   = "template-app"
repository_url = "https://github.com/yourorg/template_infra_app"

# Networking
vpc_cidr              = "10.1.0.0/16"
availability_zones    = ["us-east-1a", "us-east-1b", "us-east-1c"]
public_subnet_cidrs   = ["10.1.1.0/24", "10.1.2.0/24", "10.1.3.0/24"]
private_subnet_cidrs  = ["10.1.11.0/24", "10.1.12.0/24", "10.1.13.0/24"]

# ECS
ecs_cluster_name = "app-cluster-prod"
ecs_task_cpu     = "512"
ecs_task_memory  = "1024"
app_port         = 8080
app_count        = 3

# RDS
db_instance_class     = "db.t3.small"
db_name               = "appdb"
db_username           = "admin"
db_allocated_storage  = 100

# ElastiCache
redis_node_type       = "cache.t3.small"
redis_num_cache_nodes = 2

# ALB
alb_internal = false

# Auto Scaling
min_capacity  = 2
max_capacity  = 10
cpu_threshold = 60

# Tags
additional_tags = {
  Team        = "Platform"
  CostCenter  = "Engineering"
  Compliance  = "Required"
}
