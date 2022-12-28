resource "kubernetes_namespace" "helloworld" {
  metadata {
    name = "helloworld"
  }
}
resource "kubernetes_deployment" "helloworld" {
  metadata {
    name = "helloworld"
    namespace = "helloworld"
    labels = {
      purpose = "poc"
    }
  }
  spec {
    replicas = var.helloworld_replicas
    selector {
      match_labels = {
        purpose = "poc"
      }
    }
    template {
      metadata {
        labels = {
          purpose = "poc"
        }
      }
      spec {
        container {
          image = "nginx:latest"
          name = "helloworld"
        }
      }
    }
  }
}     


