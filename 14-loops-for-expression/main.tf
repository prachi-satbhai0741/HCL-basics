# ==============================================================
# LAB 14 - Loops: for Expressions
#
# WHAT THIS LAB TEACHES:
#   - for expression to transform a list into a new list
#   - for expression to transform a map into a new map
#   - Filtering with if inside a for expression
#   - The difference between for_each (creates resources)
#     and for expression (transforms data)
#
# KEY DIFFERENCE:
#   for_each  = a meta-argument on a resource block
#               "create one resource per item"
#
#   for expression = used inside locals or outputs
#                    "transform this collection into a new one"
# ==============================================================

terraform {
  required_version = ">= 1.5"
  required_providers {
    local = { source = "hashicorp/local", version = "~> 2.4" }
  }
}

provider "local" {}

# for EXPRESSION: list to list
# Syntax: [for item in list : transform(item)]
# Read as: "for each item in list, produce transform(item),
#           collect all results into a new list"
locals {
  tools = ["docker", "terraform", "kubernetes", "ansible"]

  # Make every tool name uppercase
  tools_upper = [for t in local.tools : upper(t)]
  # ["DOCKER", "TERRAFORM", "KUBERNETES", "ANSIBLE"]

  # Add a prefix to every tool name
  tools_with_prefix = [for t in local.tools : "tool-${t}"]
  # ["tool-docker", "tool-terraform", ...]

  # Get only the tools with more than 6 characters (filtering with if)
  tools_long = [for t in local.tools : t if length(t) > 6]
  # ["terraform", "kubernetes", "ansible"]
}

# for EXPRESSION: map to map
# Syntax: {for key, value in map : new_key => new_value}
locals {
  env_sizes = {
    dev     = "small"
    staging = "medium"
    prod    = "large"
  }

  # Transform: make all keys uppercase
  env_sizes_upper = { for k, v in local.env_sizes : upper(k) => v }
  # {DEV = "small", STAGING = "medium", PROD = "large"}

  # Transform: swap key and value
  sizes_to_env = { for k, v in local.env_sizes : v => k }
  # {small = "dev", medium = "staging", large = "prod"}

  # Filter: only keep entries where value is not "small"
  non_small_envs = { for k, v in local.env_sizes : k => v if v != "small" }
  # {staging = "medium", prod = "large"}
}

# for EXPRESSION: list to map
# Syntax: {for item in list : item => expression}
# Useful when you want to look up items by name later.
locals {
  server_names = ["web-01", "api-01", "db-01"]

  # Build a map from name to a computed value
  server_ports = { for name in local.server_names : name => 8080 }
  # {"web-01" = 8080, "api-01" = 8080, "db-01" = 8080}

  server_urls = {
    for name in local.server_names : name => "http://${name}.internal"
  }
  # {"web-01" = "http://web-01.internal", ...}
}


resource "local_file" "for_expressions" {
  filename = "${path.module}/01-for-expressions.txt"

  content = <<-EOT
    LIST TO LIST
    ------------
    original    : ${jsonencode(local.tools)}
    uppercase   : ${jsonencode(local.tools_upper)}
    with prefix : ${jsonencode(local.tools_with_prefix)}
    long only   : ${jsonencode(local.tools_long)}

    MAP TO MAP
    ----------
    original      : ${jsonencode(local.env_sizes)}
    keys upper    : ${jsonencode(local.env_sizes_upper)}
    swapped       : ${jsonencode(local.sizes_to_env)}
    non-small     : ${jsonencode(local.non_small_envs)}

    LIST TO MAP
    -----------
    server_ports  : ${jsonencode(local.server_ports)}
    server_urls   : ${jsonencode(local.server_urls)}
  EOT
}
