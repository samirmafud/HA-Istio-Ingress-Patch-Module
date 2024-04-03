# Módulo para configurar el Load Balancer desplegado por ISTIO en AWS hacia un Network Load Balancer con HTTPS

La configuración de Terraform ejecuta la aplicación de un parche al servicio istio-ingressgateway en un clúster de EKS para configurar los parámetros necesarios en el Load Balancer de Istio.

- [Características](#características)
- [Uso](#uso)
- [Variables de Entrada](#variables-de-entrada)
- [Variables de Salida](#variables-de-salida)
- [Recursos Creados](#recursos-creados)
- [Dependencias](#dependencias)


## Características

- Automatiza la actualización del kubeconfig para el clúster de EKS.

- Aplica un parche al servicio 'istio-ingressgateway' para configurar el Network Load Balancer con HTTPS en el clúster de EKS.


## Uso

Para la ejecución de la configuración se deben considerar los siguientes puntos:

- Definir el perfil que se utilizará para el despliegue de la infraestructura (apificacion, apolo) en la variable 'profile'.

- Definir el namespace de Istio donde se desplegará el Load Balancer en la variable 'istio_namespace_gateway'.

- Definir el nombre del servicio que despliega el Load Balancer en la variable 'istio_service_gateway'.

- Definir los puertos SSL que utilizará el Load Balancer en la variable 'lb_ssl_ports'.

Una vez se completa con lo anterior, se debe desplegar este módulo a través del módulo de despliegue de Istio ubicado en el repositorio 'istio-eks-nlb-patch' y seguir los pasos indicados en ese módulo.


## Variables de entrada

- `aws_region` - La región de AWS a utilizar.

- `profile` - Nombre del perfil para el despliegue de la infraestructura.

- `cluster_name` - Nombre del clúster de EKS donde está desplegado Istio.

- `subnets_id` - ID de las subnets donde está hospedado el clúster de EKS.

- `istio_namespace_gateway` - Nombre del espacio de trabajo para el gateway de Istio.

- `istio_service_gateway` - Nombre del Servicio de Istio para el istio-ingressgateway.

- `lb_ssl_ports` - Puertos SSL para el Load Balancer.


## Variables de salida

El código actualmente no produce variables de salida.


## Recursos creados

El despliegue de Terraform crea los siguientes recursos en la cuenta de AWS:

- Crea un recurso nulo para ejecutar la actualización de la configuración y el contexto del Kubeconfig del clúster de EKS.

- Crea un recurso nulo para ejecutar un parche en el servicio istio-ingressgateway para que el Load Balancer esté configurado como un NLB con HTTPS en el puerto 443 y asociado a las subredes del clúster de EKS.


## Dependencias

Este módulo depende de los siguientes recursos:

- Recursos de red desplegados en la cuenta de AWS obtenidos del módulo Unity-Networking-deploy.

- Un clúster de EKS desplegado en la cuenta de AWS obtenido del módulo Unity-EKS-deploy.

- Tener configurados los recursos de Istio ('istio_base', 'istio_d' e 'istio_ingress') en el clúster de EKS obtenidos del módulo 'istio-eks-deploy'.