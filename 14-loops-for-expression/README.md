# 14 - Loops: for Expressions

![Terraform](https://img.shields.io/badge/terraform-%3E%3D1.5-623CE4?logo=terraform&logoColor=white)
![Provider](https://img.shields.io/badge/provider-local-gray)
![AWS Required](https://img.shields.io/badge/AWS-not%20required-success)
![Difficulty](https://img.shields.io/badge/difficulty-intermediate-yellow)
![Concept](https://img.shields.io/badge/concept-for%20expressions-blue)

---

## What You Learn

- `for` expression to transform a list into a new list
- `for` expression to transform a map into a new map
- `for` expression to turn a list into a map
- Filtering with `if` inside a for expression
- The difference between `for_each` (resource loop) and `for` (data transform)

---

## Key Syntax

```hcl
# list to list
[for item in list : upper(item)]

# list to list with filter
[for item in list : item if length(item) > 5]

# map to map
{for k, v in map : upper(k) => v}

# list to map
{for item in list : item => length(item)}
```

---

## Step-by-Step

**Step 1** - Apply:

```bash
cd 14-loops-for-expression
terraform init
terraform apply
cat 01-for-expressions.txt
```

**Step 2** - Trace through each block in the output file and match it back to the `main.tf` locals that produced it.

**Step 3** - Practice in the console:

```bash
terraform console

# list to list
> [for s in ["a", "b", "c"] : upper(s)]

# list to list with filter
> [for s in ["go", "terraform", "hcl"] : s if length(s) > 3]

# map to map
> {for k, v in {a = 1, b = 2} : k => v * 10}

# list to map
> {for s in ["web", "api", "db"] : s => "${s}.internal"}

> exit
```

**Step 4** - Clean up:

```bash
terraform destroy
```

---

## Congratulations

You have completed all 14 hcl-basics labs. You now know:

- All HCL data types: string, number, bool, list, map, object
- Variables and locals
- Outputs
- Expressions and conditionals
- 25+ built-in functions
- All three loop mechanisms: count, for_each, for expressions

You are ready for the `terraform-basics` repo to apply all of this to real AWS infrastructure.

---

## Challenge

Write a for expression that takes this list and produces a map of name to its length:

```hcl
["docker", "terraform", "kubernetes"]
# result: {"docker" = 6, "terraform" = 9, "kubernetes" = 10}
```
