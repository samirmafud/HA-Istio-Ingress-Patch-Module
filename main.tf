# Módulo para configurar el Load Balancer desplegado por ISTIO en AWS hacia un Network Load Balancer con HTTPS

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

  triggers = {
    namespace = var.istio_namespace_gateway
    gateway   = var.istio_service_gateway
  }
  
  # Ejecuta un comando para revertir los cambios cuando se destruya la infraestructura
  provisioner "local-exec" {
    when    = destroy
    command = <<-EOT
      kubectl -n ${self.triggers.namespace} patch service ${self.triggers.gateway} --patch '{
        "metadata": {
          "annotations": null
        }
      }'
    EOT
  }

  depends_on = [null_resource.configure_kubectl]
}