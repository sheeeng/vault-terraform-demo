provider "google" {
  version = "~> 3.10"
}

provider "kubernetes" {
  version = "~> 1.11"
  host    = google_container_cluster.kubernetes_cluster.endpoint
  token   = data.google_client_config.default.access_token

  cluster_ca_certificate = base64decode(
    google_container_cluster.kubernetes_cluster.master_auth.0.cluster_ca_certificate
  )
}

provider "helm" {
  version = "~> 1.0"
  kubernetes {
    host  = google_container_cluster.kubernetes_cluster.endpoint
    token = data.google_client_config.default.access_token

    cluster_ca_certificate = base64decode(
      google_container_cluster.kubernetes_cluster.master_auth.0.cluster_ca_certificate
    )
  }
}
