terraform {
  required_version = ">= 1.6.0"

  required_providers {
    docker = {
      source  = "kreuzwerker/docker"
      version = "~> 3.0"
    }
  }
}

provider "docker" {}

# Сеть (аналог VPC)

resource "docker_network" "app_net" {
  name = "${var.project_name}-network"
}

# Том для данных (диски)

resource "docker_volume" "data_volume" {
  name = "${var.project_name}-data"
}

# Аналитическая БД (Postgres)

resource "docker_container" "analytics_db" {
  name  = "${var.project_name}-analytics-db"
  image = var.postgres_image
  restart = "unless-stopped"

  env = [
    "POSTGRES_USER=${var.db_username}",
    "POSTGRES_PASSWORD=${var.db_password}",
    "POSTGRES_DB=${var.db_name}",
  ]

  networks_advanced {
    name = docker_network.app_net.name
  }

  mounts {
    target = "/var/lib/postgresql/data"
    source = docker_volume.data_volume.name
    type   = "volume"
  }

  ports {
    internal = 5432
    external = var.db_external_port
  }
}


# Kafka (событийная шина)

resource "docker_container" "kafka" {
  name  = "${var.project_name}-kafka"
  image = var.kafka_image
  restart = "unless-stopped"

  env = [
    "KAFKA_CFG_LISTENERS=PLAINTEXT://:9092",
    "KAFKA_CFG_ADVERTISED_LISTENERS=PLAINTEXT://kafka:9092",
    "KAFKA_CFG_ZOOKEEPER_CONNECT=",
    "KAFKA_ENABLE_KRAFT=yes",
    "KAFKA_CFG_PROCESS_ROLES=broker,controller",
    "KAFKA_CFG_CONTROLLER_QUORUM_VOTERS=1@localhost:9093",
    "KAFKA_CFG_LISTENER_SECURITY_PROTOCOL_MAP=CONTROLLER:PLAINTEXT,PLAINTEXT:PLAINTEXT",
    "KAFKA_CFG_CONTROLLER_LISTENER_NAMES=CONTROLLER",
    "KAFKA_CFG_INTER_BROKER_LISTENER_NAME=PLAINTEXT"
  ]

  networks_advanced {
    name = docker_network.app_net.name
  }

  ports {
    internal = 9092
    external = var.kafka_external_port
  }
}

# Портал самообслуживания
resource "docker_container" "portal" {
  name  = "${var.project_name}-portal"
  image = var.portal_image
  restart = "unless-stopped"

  networks_advanced {
    name = docker_network.app_net.name
  }

  ports {
    internal = 80
    external = var.portal_external_port
  }
}

# Доменные сервисы (медицина/финтех)
resource "docker_container" "domain_services" {
  name  = "${var.project_name}-domain-services"
  image = var.domain_services_image
  restart = "unless-stopped"

  networks_advanced {
    name = docker_network.app_net.name
  }

  ports {
    internal = 8080
    external = var.domain_services_external_port
  }
}

# ETL / Data Platform job
resource "docker_container" "etl" {
  name  = "${var.project_name}-etl"
  image = var.etl_image
  restart = "unless-stopped"
  command = ["sleep", "infinity"]

  networks_advanced {
    name = docker_network.app_net.name
  }
}

# API Gateway

resource "docker_container" "api_gateway" {
  name  = "${var.project_name}-api-gateway"
  image = var.api_gateway_image
  restart = "unless-stopped"

  networks_advanced {
    name = docker_network.app_net.name
  }

  ports {
    internal = 80
    external = var.api_gateway_external_port
  }
}
