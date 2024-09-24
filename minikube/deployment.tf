provider "kubernetes" {
  config_path = "~/.kube/config"
}

resource "kubernetes_deployment" "hello" {
  metadata {
    name      = "hello-deployment"
    namespace = "default"
    labels = {
      app = "hello"
    }
  }

  spec {
    replicas = 1

    selector {
      match_labels = {
        app = "hello"
      }
    }

    strategy {
      type = "RollingUpdate"
    }

    template {
      metadata {
        labels = {
          app = "hello"
        }
      }

      spec {
        container {
          name  = "hello"
          image = "gcr.io/google-samples/hello-app:2.0"

          port {
            container_port = 8080
          }
        }
      }
    }
  }
}

resource "kubernetes_service" "hello" {
  metadata {
    name      = "hello-service"
    namespace = "default"
  }

  spec {
    selector = {
      app = "hello"
    }

    port {
      name       = "http"
      protocol   = "TCP"
      port       = 8081
      target_port = 8080
    }

    type = "ClusterIP"
  }
}

resource "kubernetes_ingress" "hello" {
  metadata {
    name      = "hello-ingress"
    namespace = "default"
    annotations = {
      "nginx.ingress.kubernetes.io/rewrite-target" = "/$1"
      "nginx.ingress.kubernetes.io/load-balance"   = "least_conn"
      "nginx.ingress.kubernetes.io/affinity"       = "none"
    }
  }

  spec {
    ingress_class_name = "nginx"

    rule {
      http {
        path {
          path     = "/(.*)"
          path_type = "Prefix"

          backend {
            service {
              name = "hello-service"
              port {
                number = 8081
              }
            }
          }
        }
      }
    }
  }
}
