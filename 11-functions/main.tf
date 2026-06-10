# ==============================================================
# LAB 11 - Built-in Functions
#
# WHAT THIS LAB TEACHES:
#   - The most commonly used built-in functions, grouped by category
#   - How to test functions quickly using terraform console
#
# TIP: Open terraform console in a separate terminal while reading
#      this file and test each function as you encounter it.
#      Run: terraform console
# ==============================================================

terraform {
  required_version = ">= 1.5"
  required_providers {
    local = { source = "hashicorp/local", version = "~> 2.4" }
  }
}

provider "local" {}

locals {
  # STRING FUNCTIONS
  s = "  Hello Terraform World  "

  fn_upper     = upper(local.s)                       # "  HELLO TERRAFORM WORLD  "
  fn_lower     = lower(local.s)                       # "  hello terraform world  "
  fn_trimspace = trimspace(local.s)                   # "Hello Terraform World"
  fn_replace   = replace("hello-world", "-", "_")    # "hello_world"
  fn_split     = split(",", "dev,staging,prod")       # ["dev","staging","prod"]
  fn_join      = join(" | ", ["dev","staging","prod"])# "dev | staging | prod"
  fn_length_s  = length("terraform")                  # 9
  fn_substr    = substr("terraform", 0, 5)            # "terra"
  fn_format    = format("Hello %s on port %d", "World", 8080)

  # NUMERIC FUNCTIONS
  fn_max   = max(3, 1, 9, 5, 2)    # 9
  fn_min   = min(3, 1, 9, 5, 2)    # 1
  fn_abs   = abs(-42)               # 42
  fn_ceil  = ceil(1.2)              # 2   (round up)
  fn_floor = floor(1.9)             # 1   (round down)

  # COLLECTION FUNCTIONS (lists and maps)
  my_list = ["banana", "apple", "cherry", "apple", "date"]

  fn_length_l  = length(local.my_list)                 # 5
  fn_contains  = contains(local.my_list, "apple")      # true
  fn_contains2 = contains(local.my_list, "mango")      # false
  fn_distinct  = distinct(local.my_list)               # removes "apple" duplicate
  fn_sort      = sort(local.my_list)                   # alphabetical order
  fn_reverse   = reverse(["a", "b", "c"])              # ["c", "b", "a"]
  fn_flatten   = flatten([["a","b"], ["c","d"]])        # ["a","b","c","d"]
  fn_slice     = slice(local.my_list, 1, 3)            # items at index 1 and 2

  my_map = { a = 1, b = 2, c = 3 }
  fn_keys   = keys(local.my_map)                       # ["a","b","c"]
  fn_values = values(local.my_map)                     # [1,2,3]
  fn_lookup = lookup(local.my_map, "b", 0)             # 2
  fn_merge  = merge({ x = 1 }, { y = 2 })             # {x=1, y=2}

  # TYPE CONVERSION FUNCTIONS
  fn_tostring = tostring(42)             # "42"
  fn_tonumber = tonumber("99")           # 99
  fn_tobool   = tobool("true")           # true
  fn_toset    = toset(["a","b","a"])     # {"a","b"} - removes duplicates
}

resource "local_file" "functions_output" {
  filename = "${path.module}/01-functions.txt"

  content = <<-EOT
    STRING FUNCTIONS
    ----------------
    upper()      : ${local.fn_upper}
    lower()      : ${local.fn_lower}
    trimspace()  : ${local.fn_trimspace}
    replace()    : ${local.fn_replace}
    split()      : ${jsonencode(local.fn_split)}
    join()       : ${local.fn_join}
    length()     : ${local.fn_length_s}
    substr()     : ${local.fn_substr}
    format()     : ${local.fn_format}

    NUMERIC FUNCTIONS
    -----------------
    max()   : ${local.fn_max}
    min()   : ${local.fn_min}
    abs()   : ${local.fn_abs}
    ceil()  : ${local.fn_ceil}
    floor() : ${local.fn_floor}

    COLLECTION FUNCTIONS
    --------------------
    length()   : ${local.fn_length_l}
    contains() : ${local.fn_contains}
    distinct() : ${jsonencode(local.fn_distinct)}
    sort()     : ${jsonencode(local.fn_sort)}
    reverse()  : ${jsonencode(local.fn_reverse)}
    flatten()  : ${jsonencode(local.fn_flatten)}
    slice()    : ${jsonencode(local.fn_slice)}
    keys()     : ${jsonencode(local.fn_keys)}
    values()   : ${jsonencode(local.fn_values)}
    lookup()   : ${local.fn_lookup}
    merge()    : ${jsonencode(local.fn_merge)}

    TYPE CONVERSION
    ---------------
    tostring() : ${local.fn_tostring}
    tonumber() : ${local.fn_tonumber}
    tobool()   : ${local.fn_tobool}
    toset()    : ${jsonencode(local.fn_toset)}
  EOT
}
