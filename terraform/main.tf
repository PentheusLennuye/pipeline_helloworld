terraform {
  backend "kubernetes" {
    secret_suffix = "secret"
    config_path = "./kubeconfig"
  }
}
provider "kubernetes" {
  config_path = "./kubeconfig"
}
