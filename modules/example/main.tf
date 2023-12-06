resource "kubernetes_namespace" "example_namespace" {
  metadata {
    name = var.module_name
  }
}

resource "kubernetes_pod" "example_pod" {
  metadata {
    name      = "example-pod"
    namespace = kubernetes_namespace.example_namespace.metadata.0.name
    labels = {
      app = "example"
    }
  }
  spec {
    container {
      name  = "example-pod"
      image = "hashicorp/http-echo"
      args  = ["-text=${var.say_what}"]
    }
  }
}

resource "kubernetes_service_v1" "example_service" {
  metadata {
    name      = "example-service"
    namespace = kubernetes_namespace.example_namespace.metadata.0.name
  }
  spec {
    selector = {
      app = "example"
    }
    port {
      port = 5678
    }
  }
}

resource "kubernetes_ingress_v1" "ingress" {
  metadata {
    name      = "example"
    namespace = kubernetes_namespace.example_namespace.metadata[0].name
  }
  spec {
    rule {
      host = "${var.subdomain_name}.${var.domain_name}"
      http {
        path {
          backend {
            service {
              name = kubernetes_service_v1.example_service.metadata.0.name
              port {
                number = 5678
              }
            }
          }
        }
      }
    }
  }
}
