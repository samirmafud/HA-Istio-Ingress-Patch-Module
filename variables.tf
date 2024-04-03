variable "aws_region" {
  description = "Región de AWS"
  type        = string
}

variable "profile" {
  description = "Nombre de perfil para el despliegue de la infraestructura"
  type        = string
}

variable "cluster_name" {
  description = "Nombre del clúster de EKS"
  type        = string
}

variable "subnets_id" {
  description = "ID de los subnets de EKS"
  type        = set(string)
}

variable "lb_ssl_ports" {
  description = "Puertos SSL para el Load Balancer"
  type        = string
}

variable "istio_namespace_gateway" {
  description = "Espacio de trabajo para los recursos de Istio"
  type        = string
}

variable "istio_service_gateway" {
  description = "Servicio de Istio para el istio-ingressgateway"
  type        = string
}