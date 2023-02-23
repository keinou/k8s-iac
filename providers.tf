terraform {
  cloud {
    organization = "karc-io"

    workspaces {
      name = "karc-io"
    }
  }
  
  required_providers {
    oci = {
      source  = "oracle/oci"
      version = "4.109.0"
    }
  }
}
