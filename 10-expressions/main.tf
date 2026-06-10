# ==============================================================
# LAB 10 - Expressions and Conditionals
#
# WHAT THIS LAB TEACHES:
#   - Conditional (ternary) expression: condition ? yes : no
#   - Comparison operators: ==, !=, >, <, >=, <=
#   - Logical operators: &&, ||, !
#   - How to use conditions to drive different behaviour per env
# ==============================================================

terraform {
  required_version = ">= 1.5"
  required_providers {
    local = { source = "hashicorp/local", version = "~> 2.4" }
  }
}

provider "local" {}

variable "environment" { default = "dev" }
variable "enable_feature" { default = true }

# CONDITIONAL EXPRESSION
# Syntax:  condition ? value_if_true : value_if_false

locals {
  # If environment is "prod", use "t3.large". Otherwise "t2.micro".
  instance_type = var.environment == "prod" ? "t3.large" : "t2.micro"

  # If environment is "prod", run 5 replicas. Otherwise 1.
  replica_count = var.environment == "prod" ? 5 : 1

  # If environment is NOT "prod", enable debug mode.
  debug_mode = var.environment != "prod" ? true : false

  # Nested ternary - pick from three options
  # Read: if prod -> ERROR, else if staging -> WARN, else DEBUG
  log_level = var.environment == "prod" ? "ERROR" : (var.environment == "staging" ? "WARN" : "DEBUG")
}

# COMPARISON OPERATORS
locals {
  port          = 8080
  is_high_port  = local.port > 1024   # true  (8080 > 1024)
  is_http_port  = local.port == 80    # false (8080 != 80)
  is_not_prod   = var.environment != "prod"
}

# LOGICAL OPERATORS
locals {
  # true only if BOTH conditions are true
  is_prod_with_feature = var.environment == "prod" && var.enable_feature

  # true if EITHER condition is true
  is_non_prod = var.environment == "dev" || var.environment == "staging"

  # flip the value
  is_not_debug = !local.debug_mode
}


resource "local_file" "expressions" {
  filename = "${path.module}/01-expressions.txt"

  content = <<-EOT
    CONDITIONAL EXPRESSIONS
    -----------------------
    environment   = ${var.environment}
    instance_type = ${local.instance_type}
    replica_count = ${local.replica_count}
    debug_mode    = ${local.debug_mode}
    log_level     = ${local.log_level}

    COMPARISONS
    -----------
    port         = ${local.port}
    is_high_port = ${local.is_high_port}
    is_http_port = ${local.is_http_port}
    is_not_prod  = ${local.is_not_prod}

    LOGICAL OPERATORS
    -----------------
    enable_feature       = ${var.enable_feature}
    prod_with_feature    = ${local.is_prod_with_feature}
    is_non_prod          = ${local.is_non_prod}
    is_not_debug         = ${local.is_not_debug}
  EOT
}
