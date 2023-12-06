provider "kubernetes" {
  config_path = "~/.kube/config"
}

## Modules

module "example" {
  source         = "./modules/example"
  domain_name    = "example.com"
  subdomain_name = "example"
  say_what       = "what the fuck is going on?"
}
