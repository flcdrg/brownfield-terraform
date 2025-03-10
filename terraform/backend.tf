terraform {
  cloud {
    organization = "flcdrg"
    hostname     = "app.terraform.io"

    workspaces {
      name = "brownfield-dev-australiaeast"
    }
  }
}
