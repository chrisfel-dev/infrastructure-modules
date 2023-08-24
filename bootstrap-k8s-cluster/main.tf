resource "kubernetes_namespace" "argocd" {
  metadata {
    name = var.argocd_namespace
    labels = {
      "pod-security.kubernetes.io/enforce": "baseline"
    }
  }

  lifecycle {
    ignore_changes = [metadata[0].labels]
  }
}
#
resource "kubernetes_manifest" "catalog_source" {
  manifest = {
    apiVersion = "operators.coreos.com/v1alpha1"
    kind       = "CatalogSource"

    metadata = {
      name = "argocd-catalog"
      namespace = "olm"
    }

    spec = {
      sourceType  = "grpc"
      image       = "quay.io/argoprojlabs/argocd-operator-registry@sha256:dcf6d07ed5c8b840fb4a6e9019eacd88cd0913bc3c8caa104d3414a2e9972002" # replace with your index image
      displayName = "Argo CD Operators"
      publisher   =  "Argo CD Community"
    }
  }
}
#
resource "kubernetes_manifest" "operator_group" {
  manifest = {
    apiVersion = "operators.coreos.com/v1"
    kind       = "OperatorGroup"

    metadata = {
      name = "argocd-operator"
      namespace = var.argocd_namespace
    }

    spec = {
      targetNamespaces = ["argocd"]
    }
  }
}
#
#
resource "kubernetes_manifest" "argocd_subscription" {
  manifest = {
    apiVersion = "operators.coreos.com/v1alpha1"
    kind       = "Subscription"

    metadata = {
      name = "argocd-operator"
      namespace = var.argocd_namespace
    }

    spec = {
      channel = var.argocd_subscription_channel
      name    = "argocd-operator"
      source  = "argocd-catalog"
      sourceNamespace = "olm"
    }
  }
}