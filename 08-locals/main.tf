# ==============================================================
# LAB 08 - Locals
#
# WHAT THIS LAB TEACHES:
#   - What a locals block is
#   - How locals differ from variables
#   - Computing values once and reusing them everywhere
#   - The common_tags pattern used in real Terraform projects
#   - Building derived values from variables
#
# RULE: Use locals when you want to compute a value ONCE
#       and reference it in multiple places without repeating
#       the same expression over and over.
# ==============================================================

terraform {
  required_version = ">= 1.5"
  required_providers {
    local = {
      source  = "hashicorp/local"
      version = "~> 2.4"
    }
  }
}

provider "local" {}

variable "project"     { default = "hcl-lab" }
variable "environment" { default = "dev" }
variable "team"        { default = "platform" }
variable "region"      { default = "ap-south-1" }

# THE LOCALS BLOCK
locals {
  # 1. A simple computed string
  #    Instead of writing "${var.project}-${var.environment}" everywhere,
  #    you define it once and use local.name_prefix everywhere.
  name_prefix = "${var.project}-${var.environment}"

  # 2. Common tags - the most used locals pattern in Terraform
  #    Define once, attach to every single resource.
  #    This guarantees every resource is tagged consistently.
  common_tags = {
    Project     = var.project
    Environment = var.environment
    Team        = var.team
    Region      = var.region
    ManagedBy   = "Terraform"
  }

  # 3. A local referencing another local
  #    log_prefix uses local.name_prefix, which was defined above.
  #    Terraform resolves them in the right order automatically.
  log_prefix = "[${upper(local.name_prefix)}]"
}

# USING LOCALS IN RESOURCES
resource "local_file" "server_config" {
  # local.name_prefix used in the filename
  filename = "${path.module}/${local.name_prefix}-server.txt"

  content = <<-EOT
    Config for: ${local.name_prefix}
    Log prefix: ${local.log_prefix}

    Tags that would go on this resource:
    ${jsonencode(local.common_tags)}
  EOT
}

resource "local_file" "db_config" {
  filename = "${path.module}/${local.name_prefix}-database.txt"

  content = <<-EOT
    Database config for: ${local.name_prefix}

    Tags:
    Project     = ${local.common_tags.Project}
    Environment = ${local.common_tags.Environment}
    Team        = ${local.common_tags.Team}
  EOT
}

# LOCALS WITH LOGIC
locals {
  # Compute different values based on the environment variable
  is_production = var.environment == "prod"
  log_level     = var.environment == "prod" ? "ERROR" : "DEBUG"
  replica_count = var.environment == "prod" ? 3 : 1
}

resource "local_file" "env_config" {
  filename = "${path.module}/${local.name_prefix}-env.txt"

  content = <<-EOT
    Environment : ${var.environment}
    Is Prod     : ${local.is_production}
    Log Level   : ${local.log_level}
    Replicas    : ${local.replica_count}
  EOT
}
