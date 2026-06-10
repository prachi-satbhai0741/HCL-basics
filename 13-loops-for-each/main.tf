# ==============================================================
# LAB 13 - Loops: for_each
#
# WHAT THIS LAB TEACHES:
#   - for_each: create one resource per item in a map or set
#   - each.key and each.value inside the resource block
#   - for_each with a map (key-value pairs)
#   - for_each with a set (unique values only)
#   - Why for_each is safer than count when items have names
#
# KEY DIFFERENCE FROM count:
#   count creates resources named [0], [1], [2]
#   for_each creates resources named ["dev"], ["prod"], ["web"]
#   If you remove an item from the middle of a count list,
#   Terraform renumbers everything. With for_each, only the
#   removed item is destroyed. Much safer.
# ==============================================================

terraform {
  required_version = ">= 1.5"
  required_providers {
    local = { source = "hashicorp/local", version = "~> 2.4" }
  }
}

provider "local" {}

# for_each WITH A MAP
variable "environments" {
  description = "Map of environment name to instance type"
  type        = map(string)
  default = {
    dev     = "t2.micro"
    staging = "t2.small"
    prod    = "t3.large"
  }
}

resource "local_file" "env_config" {
  # for_each takes the map - one resource per map entry
  for_each = var.environments

  # each.key   is "dev", "staging", or "prod"
  # each.value is "t2.micro", "t2.small", or "t3.large"
  filename = "${path.module}/${each.key}-config.txt"

  content = <<-EOT
    Environment  : ${each.key}
    Instance Type: ${each.value}
  EOT
}

# for_each WITH A SET
variable "regions" {
  description = "Regions to create config files for"
  type        = list(string)
  default     = ["us-east-1", "us-west-2", "ap-south-1"]
}

resource "local_file" "region_config" {
  # toset() converts the list to a set (removes duplicates, enables for_each)
  for_each = toset(var.regions)

  # For a set, each.key and each.value are the same: the item itself
  filename = "${path.module}/region-${each.value}.txt"
  content  = "Region: ${each.value}"
}

# REFERENCING for_each RESOURCES
output "env_config_files" {
  description = "Map of environment to config filename"
  # local_file.env_config is a map: {"dev" = {...}, "staging" = {...}, "prod" = {...}}
  # We extract just the filename from each
  value = { for k, v in local_file.env_config : k => v.filename }
}

output "dev_config_file" {
  description = "Path to the dev config file specifically"
  value = local_file.env_config["dev"].filename
}
