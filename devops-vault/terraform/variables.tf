variable "username" {
  type    = string
  default = "ci-user"
}

variable "access_key" {
  type    = string
  default = "" # opcional; provider puede generar
}

variable "secret_key" {
  type    = string
  default = ""
}

variable "bucket_name" {
  type    = string
  default = "uploads"
}
