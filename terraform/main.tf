terraform {
  backend "kubernetes" {
    secret_suffix = "helloworld_main"
    config_path = "./kubeconfig"
  }
}
provider "kubernetes" {
  config_path = "./kubeconfig"
}
