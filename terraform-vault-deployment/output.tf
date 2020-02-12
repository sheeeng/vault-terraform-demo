output "vault_address" {
  value = "http://${data.kubernetes_service.vault_svc.load_balancer_ingress.0.ip}:8200"
}