# 10 - Expressions and Conditionals

![Terraform](https://img.shields.io/badge/terraform-%3E%3D1.5-623CE4?logo=terraform&logoColor=white)
![Provider](https://img.shields.io/badge/provider-local-gray)
![AWS Required](https://img.shields.io/badge/AWS-not%20required-success)
![Difficulty](https://img.shields.io/badge/difficulty-intermediate-yellow)
![Concept](https://img.shields.io/badge/concept-conditionals-blue)

---

## What You Learn

- Conditional (ternary) expression: `condition ? true_val : false_val`
- Comparison operators: `==`, `!=`, `>`, `<`
- Logical operators: `&&`, `||`, `!`

---

## Key Syntax

```hcl
# Conditional: if prod use t3.large, else t2.micro
instance_type = var.env == "prod" ? "t3.large" : "t2.micro"

# Logical AND - both must be true
is_prod_debug = var.env == "prod" && var.debug == true

# Logical OR - at least one must be true
is_lower_env = var.env == "dev" || var.env == "staging"
```

---

## Step-by-Step

**Step 1** - Run with default (dev):

```bash
cd 10-expressions
terraform init
terraform apply
cat 01-expressions.txt
```

Note the instance_type is `t2.micro` and log_level is `DEBUG`.

**Step 2** - Run as prod and compare:

```bash
terraform apply -var="environment=prod"
cat 01-expressions.txt
```

Now instance_type is `t3.large`, replicas is 5, log_level is `ERROR`.

**Step 3** - Try in the console:

```bash
terraform console
> "prod" == "prod" ? "yes" : "no"
> "dev" != "prod"
> true && false
> true || false
> !true
> exit
```

**Step 4** - Clean up:

```bash
terraform destroy
```

---

## Challenge

Add a local `backup_schedule` that is `"hourly"` for prod and `"daily"` for everything else. Write it to the output file.
