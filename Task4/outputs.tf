output "docker_network" {
  description = "Docker-сеть"
  value       = docker_network.app_net.name
}

output "portal_url" {
  description = "URL портала самообслуживания"
  value       = "http://localhost:${var.portal_external_port}"
}

output "api_gateway_url" {
  description = "URL API Gateway"
  value       = "http://localhost:${var.api_gateway_external_port}"
}

output "domain_services_url" {
  description = "URL доменных сервисов"
  value       = "http://localhost:${var.domain_services_external_port}"
}

output "analytics_db_connection" {
  description = "Строка подключения к аналитической БД"
  value       = "postgres://${var.db_username}:${var.db_password}@localhost:${var.db_external_port}/${var.db_name}"
  sensitive   = true
}

output "kafka_bootstrap" {
  description = "Bootstrap сервер Kafka"
  value       = "localhost:${var.kafka_external_port}"
}
