# ==============================================================
# LAB 09 - Outputs
#
# WHAT THIS LAB TEACHES:
#   - Declaring output values
#   - Why outputs matter (CI/CD, scripts, modules)
#   - Sensitive outputs
#   - Querying outputs from the terminal
# ==============================================================

terraform {
  required_version = ">= 1.5"
  required_providers {
    local  = { source = "hashicorp/local",  version = "~> 2.4" }
    random = { source = "hashicorp/random", version = "~> 3.5" }
  }
}

provider "local" {}
provider "random" {}


# Resources whose attributes we will expose as outputs
resource "random_id" "app_id" {
  byte_length = 4
}

resource "random_pet" "server_name" {
  length    = 2
  separator = "-"
}

resource "random_password" "secret" {
  length  = 16
  special = true
}

resource "local_file" "config" {
  filename = "${path.module}/app.conf"
  content  = "app_id = ${random_id.app_id.hex}"
}

# OUTPUT BLOCKS
#
# An output block exposes a value after terraform apply.
# Syntax:
#   output "name" {
#     description = "what this value is"
#     value       = the_value_to_expose
#   }
#
# After apply, run:
#   terraform output           - see all outputs
#   terraform output app_id    - see one output
#   terraform output -json     - see all as JSON (useful in scripts)

output "app_id" {
  description = "Unique app identifier (hex)"
  value       = random_id.app_id.hex
}

output "server_name" {
  description = "Auto-generated server name"
  value       = random_pet.server_name.id
}

output "app_url" {
  description = "Simulated application URL built from the app ID"
  value       = "https://app-${random_id.app_id.hex}.example.com"
}

output "config_file_path" {
  description = "Path to the config file that was created"
  value       = local_file.config.filename
}

# Sensitive output - value is hidden in terminal logs
# To see it: terraform output app_secret
output "app_secret" {
  description = "Application secret (hidden from normal output)"
  value       = random_password.secret.result
  sensitive   = true
}

# Map output - group related values together
output "app_summary" {
  description = "All app info in one map"
  value = {
    id     = random_id.app_id.hex
    name   = random_pet.server_name.id
    url    = "https://app-${random_id.app_id.hex}.example.com"
    config = local_file.config.filename
  }
}
