locals {
  name_prefix = "${var.project_name}-${var.environment}"
  
  common_tags = merge(
    var.additional_tags,
    {
      Project     = var.project_name
      Environment = var.environment
      ManagedBy   = "Terraform"
    }
  )

  # Application configuration
  app_name = "spring-boot-app"
  
  # Database configuration
  db_port = 5432
  
  # Redis configuration
  redis_port = 6379
}
