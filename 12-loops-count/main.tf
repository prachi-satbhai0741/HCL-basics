# ==============================================================
# LAB 12 - Loops: count
#
# WHAT THIS LAB TEACHES:
#   - count: create multiple copies of one resource
#   - count.index: the current iteration number (starts at 0)
#   - Referencing a specific instance: resource.name[index]
#   - Referencing ALL instances with a splat: resource.name[*].attr
#
# count is the simplest loop in Terraform.
# Use it when you want N copies of the same resource.
# ==============================================================

terraform {
  required_version = ">= 1.5"
  required_providers {
    local = { source = "hashicorp/local", version = "~> 2.4" }
  }
}

provider "local" {}

# BASIC count
resource "local_file" "server" {
  # count = 3 means: create this resource 3 times
  count = 3

  # count.index is 0 on the first run, 1 on the second, 2 on third
  # count.index + 1 gives us 1, 2, 3 (more human-friendly)
  filename = "${path.module}/server-${count.index + 1}.txt"

  content = "I am server number ${count.index + 1} of 3."
}

# count FROM A VARIABLE
variable "file_count" {
  description = "How many files to create"
  type        = number
  default     = 4
}

resource "local_file" "log" {
  count    = var.file_count
  filename = "${path.module}/log-${count.index}.txt"
  content  = "Log file ${count.index}. Total files: ${var.file_count}."
}

# REFERENCING count RESOURCES
output "server_filenames" {
  description = "Filenames of all created server files"
  # [*] is the splat - it means: from every instance, get .filename
  value = local_file.server[*].filename
}

output "first_server_filename" {
  description = "Filename of the first server file"
  value = local_file.server[0].filename
}

output "log_filenames" {
  description = "Filenames of all log files"
  value = local_file.log[*].filename
}
