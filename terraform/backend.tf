terraform {
  cloud {
    organization  = "karc-io"
    
    workspaces {
      name = "k8s-iac"
    }
  }
}