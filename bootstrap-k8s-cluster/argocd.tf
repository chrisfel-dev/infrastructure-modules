resource "kubernetes_manifest" "argocd_instance" {
  manifest = {
    apiVersion = "argoproj.io/v1alpha1"
    kind       = "ArgoCD"

    metadata = {
      name = "argocd"
      namespace = var.argocd_namespace
    }

    spec = {
      server = {
        host = var.argocd_host
        ingress = {
           enabled = false
        }
        insecure =  true
        extraCommandArgs = ["--rootpath", var.argocd_root_path]
      }
    }
  }
}