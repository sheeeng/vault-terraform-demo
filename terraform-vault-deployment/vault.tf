resource "kubernetes_namespace" "vault" {
  metadata {
    name = "vault"
  }
}

resource "kubernetes_namespace" "consul" {
  metadata {
    name = "consul"
  }
}

resource "helm_release" "consul" {
  name      = "consul"
  chart     = "consul-helm"
  namespace = kubernetes_namespace.consul.metadata.0.name

  values = [
    templatefile("consul/values.tmpl", { replicas = var.initial_node_count })
  ]
}

resource "helm_release" "vault" {
  depends_on = [helm_release.consul]

  name      = "vault"
  chart     = "vault-helm"
  namespace = kubernetes_namespace.vault.metadata.0.name

  values = [
    templatefile("vault/values.tmpl", { replicas = var.initial_node_count })
  ]
}

data "kubernetes_service" "vault_svc" {
  depends_on = [
    helm_release.vault
  ]

  metadata {
    namespace = "vault"
    name      = "vault-ui"
  }
}