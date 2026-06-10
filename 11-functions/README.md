# 11 - Functions

![Terraform](https://img.shields.io/badge/terraform-%3E%3D1.5-623CE4?logo=terraform&logoColor=white)
![Provider](https://img.shields.io/badge/provider-local-gray)
![AWS Required](https://img.shields.io/badge/AWS-not%20required-success)
![Difficulty](https://img.shields.io/badge/difficulty-intermediate-yellow)
![Concept](https://img.shields.io/badge/concept-built--in%20functions-blue)
![Functions](https://img.shields.io/badge/functions-25%2B-informational)

---

## What You Learn

- String functions: `upper`, `lower`, `trimspace`, `replace`, `split`, `join`, `substr`, `format`
- Numeric functions: `max`, `min`, `abs`, `ceil`, `floor`
- Collection functions: `length`, `contains`, `distinct`, `sort`, `flatten`, `keys`, `values`, `lookup`, `merge`
- Type conversion: `tostring`, `tonumber`, `tobool`, `toset`

---

## Step-by-Step

**Step 1** - Open two terminals. In the first, run:

```bash
cd 11-functions
terraform init
terraform apply
cat 01-functions.txt
```

**Step 2** - In the second terminal, explore functions interactively:

```bash
cd 11-functions
terraform console

> upper("hello")
> trimspace("  spaces  ")
> split(",", "a,b,c")
> join(" - ", ["x", "y", "z"])
> max(1, 9, 3, 7)
> flatten([["a","b"], ["c"]])
> distinct(["a","b","a","c"])
> merge({"a"=1}, {"b"=2})
> exit
```

**Step 3** - Clean up:

```bash
terraform destroy
```

---

## Tip

`terraform console` is your best tool for learning functions. Test any expression instantly without writing a full config file.

---

## Challenge

In the console, figure out what `formatdate("DD MMM YYYY", timestamp())` returns. Then add it as a local and write it to a file called `02-timestamp.txt`.
