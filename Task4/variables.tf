variable "project_name" {
  description = "Префикс"
  type        = string
  default     = "future20"
}

# Docker images
variable "postgres_image" {
  description = "Образ PostgreSQL"
  type        = string
  default     = "postgres:15-alpine"
}

variable "kafka_image" {
  description = "Образ Kafka'"
  type        = string
  default     = "nginx:alpine"
}

variable "portal_image" {
  description = "Образ Портала"
  type        = string
  default     = "nginx:alpine"
}

variable "domain_services_image" {
  description = "Образ доменных сервисов"
  type        = string
  default     = "nginx:alpine"
}

variable "etl_image" {
  description = "Образ ETL контейнера"
  type        = string
  default     = "alpine:latest"
}

variable "api_gateway_image" {
  description = "Образ API Gateway (stub, nginx)"
  type        = string
  default     = "nginx:alpine"
}

# DB credentials

variable "db_username" {
  description = "Пользователь Postgres"
  type        = string
  default     = "analytics_user"
}

variable "db_password" {
  description = "Пароль Postgres"
  type        = string
  sensitive   = true
}

variable "db_name" {
  description = "Имя аналитической БД"
  type        = string
  default     = "analytics"
}

variable "db_external_port" {
  description = "Внешний порт для Postgres"
  type        = number
  default     = 5432
}

variable "kafka_external_port" {
  description = "Внешний порт для Kafka"
  type        = number
  default     = 9092
}

variable "portal_external_port" {
  description = "Внешний порт портала"
  type        = number
  default     = 8080
}

variable "domain_services_external_port" {
  description = "Внешний порт доменных сервисов"
  type        = number
  default     = 8081
}

variable "api_gateway_external_port" {
  description = "Внешний порт API Gateway"
  type        = number
  default     = 8088
}
