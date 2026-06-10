# 08 - Locals

![Terraform](https://img.shields.io/badge/terraform-%3E%3D1.5-623CE4?logo=terraform&logoColor=white)
![Provider](https://img.shields.io/badge/provider-local-gray)
![AWS Required](https://img.shields.io/badge/AWS-not%20required-success)
![Difficulty](https://img.shields.io/badge/difficulty-beginner-brightgreen)
![Concept](https://img.shields.io/badge/concept-locals-blue)

---

## What You Learn

- What a `locals` block is and how it differs from `variable`
- Reference with `local.name` (singular)
- Defining a name prefix used everywhere
- The `common_tags` pattern used in every real Terraform project
- Locals that reference other locals

---

## locals vs variable - one more time

```
variable  = value passed IN from outside (CLI, .tfvars, env var)
local     = value computed INSIDE the config
```

A local can use variables. A variable cannot use locals.

---

## Step-by-Step

**Step 1** - Apply with defaults:

```bash
cd 08-locals
terraform init
terraform apply
ls *.txt
```

**Step 2** - Read the output files:

```bash
cat hcl-lab-dev-server.txt
cat hcl-lab-dev-database.txt
cat hcl-lab-dev-env.txt
```

Notice `hcl-lab-dev` appears in every filename. That came from `local.name_prefix`.

**Step 3** - Change to prod and reapply:

```bash
terraform apply -var="environment=prod"
ls *.txt
```

New files appear with `hcl-lab-prod` prefix. The old dev files are destroyed.

**Step 4** - Read the prod env file:

```bash
cat hcl-lab-prod-env.txt
```

Notice `is_production = true`, `log_level = ERROR`, `replicas = 3`.

**Step 5** - Clean up:

```bash
terraform destroy
```

---

## The common_tags Pattern

In real Terraform projects every single resource should have tags. Instead of repeating the tag block on every resource, define it once as a local:

```hcl
locals {
  common_tags = {
    Project     = var.project
    Environment = var.environment
    ManagedBy   = "Terraform"
  }
}

# Then on every resource:
tags = local.common_tags

# Or merge in resource-specific tags:
tags = merge(local.common_tags, { Name = "my-server" })
```

---

## Challenge

Add a new local called `s3_bucket_name` that combines `name_prefix` and a suffix `-assets`. Write it to a new file `bucket-name.txt`.
