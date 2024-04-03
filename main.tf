# Recupera la información de las subnets privadas existentes a partir de los IDs generados en 'var.subnets_id'
data "aws_subnet" "module_subnet" {
  for_each = var.subnets_id
  id       = each.value
}

# Ejecuta los comandos de Kubernetes para actualizar el kubeconfig del clúster de EKS
resource "null_resource" "configure_kubectl" {
  provisioner "local-exec" {
    command = "aws eks --region ${var.aws_region} update-kubeconfig --name ${var.cluster_name} --profile ${var.profile}"
  }
}

# Ejecuta un parche en el servicio istio-ingressgateway en el namespace especificado para configurar el Load Balancer y asociarlo a las subnets del clúster de EKS
resource "null_resource" "patch_deployment" {
  provisioner "local-exec" {
    command = <<-EOT
      kubectl -n ${var.istio_namespace_gateway} patch service ${var.istio_service_gateway} --patch '{
        "metadata": {
          "annotations": {
            "service.beta.kubernetes.io/aws-load-balancer-backend-protocol": "tcp",
            "service.beta.kubernetes.io/aws-load-balancer-ssl-ports": "${var.lb_ssl_ports}",
            "service.beta.kubernetes.io/aws-load-balancer-connection-idle-timeout": "3600",
            "service.beta.kubernetes.io/aws-load-balancer-type": "nlb",
            "service.beta.kubernetes.io/aws-load-balancer-internal": "true",
            "service.beta.kubernetes.io/aws-load-balancer-subnets": "${join(",", var.subnets_id)}"
          }
        }
      }'
    EOT
  }

  depends_on = [null_resource.configure_kubectl]
}