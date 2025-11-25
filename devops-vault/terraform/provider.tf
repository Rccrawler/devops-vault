terraform {
  required_providers {
    minio = {
      source  = "aminueza/minio"
      version = ">= 3.0.0"
    }
  }
  required_version = ">= 1.0.0"
}

provider "minio" {
  # al ejecutar terraform desde tu máquina, apuntamos al minio expuesto en localhost:9000
  minio_server   = "localhost:9000"
  minio_region   = "us-east-1"
  minio_user     = "minio"       # root user del contenedor
  minio_password = "minio123"
}
