# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [Unreleased]

### Added
- Initial template structure
- Spring Boot 3 application with PostgreSQL and Redis
- Complete Terraform infrastructure for AWS (VPC, ECS, RDS, ElastiCache, ALB)
- CI/CD pipelines with GitHub Actions
- Docker and docker-compose support
- Comprehensive documentation
- Makefile for common tasks
- Setup scripts and Git hooks

### Changed
- N/A

### Deprecated
- N/A

### Removed
- N/A

### Fixed
- N/A

### Security
- N/A

## [1.0.0] - 2025-01-XX

### Added
- Full project template ready for production use
- Spring Boot REST API with CRUD operations
- Database migrations with Flyway
- Caching with Redis
- OpenAPI/Swagger documentation
- Health checks and monitoring
- Automated testing (unit and integration)
- Security scanning in CI/CD
- Blue/green deployment ready
- Auto-scaling configuration
- CloudWatch logging and metrics
- Secrets management with AWS Secrets Manager

---

## How to Update This Changelog

When making changes to the project:

1. Add entries to the `[Unreleased]` section
2. Use the following categories:
   - `Added` for new features
   - `Changed` for changes in existing functionality
   - `Deprecated` for soon-to-be removed features
   - `Removed` for now removed features
   - `Fixed` for any bug fixes
   - `Security` for vulnerability fixes

3. When releasing a new version:
   - Move items from `[Unreleased]` to a new version section
   - Update the version number and date
   - Create a new `[Unreleased]` section

Example:
```markdown
## [Unreleased]

### Added
- New feature X

## [1.1.0] - 2025-02-01

### Added
- Feature A
- Feature B

### Fixed
- Bug fix for issue #123
```
