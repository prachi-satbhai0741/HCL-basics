# 13 - Loops: for_each

![Terraform](https://img.shields.io/badge/terraform-%3E%3D1.5-623CE4?logo=terraform&logoColor=white)
![Provider](https://img.shields.io/badge/provider-local-gray)
![AWS Required](https://img.shields.io/badge/AWS-not%20required-success)
![Difficulty](https://img.shields.io/badge/difficulty-intermediate-yellow)
![Concept](https://img.shields.io/badge/concept-for_each-blue)

---

## What You Learn

- `for_each` with a map: one resource per map entry
- `each.key` and `each.value` inside the resource block
- `for_each` with a set using `toset()`
- Why `for_each` is safer than `count` for named resources

---

## Key Syntax

```hcl
# for_each with a map
resource "local_file" "config" {
  for_each = { dev = "t2.micro", prod = "t3.large" }
  filename = "${each.key}-config.txt"   # dev-config.txt
  content  = "type: ${each.value}"      # type: t2.micro
}

# for_each with a set
resource "local_file" "region" {
  for_each = toset(["us-east-1", "us-west-2"])
  filename = "region-${each.value}.txt"
}
```

---

## Step-by-Step

**Step 1** - Apply:

```bash
cd 13-loops-for-each
terraform init
terraform apply
ls *.txt
```

**Step 2** - Read the created files:

```bash
cat dev-config.txt
cat staging-config.txt
cat prod-config.txt
cat region-us-east-1.txt
```

**Step 3** - See the outputs:

```bash
terraform output
terraform output env_config_files
terraform output dev_config_file
```

**Step 4** - Add a new environment and reapply:

Open `main.tf` and add `qa = "t2.nano"` to the `environments` default map. Then:

```bash
terraform apply
ls *.txt
```

Only `qa-config.txt` was added. The others were untouched.

**Step 5** - Remove `staging` from the map and reapply:

```bash
terraform apply
```

Only `staging-config.txt` was destroyed. This is the advantage over `count`.

**Step 6** - Clean up:

```bash
terraform destroy
```

---

## Challenge

Add a new variable `services` as a `map(number)` with values `{ auth = 3000, api = 8080, frontend = 80 }`. Use `for_each` to create a config file per service showing its name and port.
