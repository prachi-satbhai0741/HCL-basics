# 12 - Loops: count

![Terraform](https://img.shields.io/badge/terraform-%3E%3D1.5-623CE4?logo=terraform&logoColor=white)
![Provider](https://img.shields.io/badge/provider-local-gray)
![AWS Required](https://img.shields.io/badge/AWS-not%20required-success)
![Difficulty](https://img.shields.io/badge/difficulty-intermediate-yellow)
![Concept](https://img.shields.io/badge/concept-count-blue)

---

## What You Learn

- `count` meta-argument to create multiple copies of one resource
- `count.index` to get the current loop number (starts at 0)
- Accessing a specific instance: `resource.name[0]`
- Getting all instances with splat: `resource.name[*].attribute`

---

## Key Syntax

```hcl
resource "local_file" "server" {
  count    = 3                                       # create 3 copies
  filename = "server-${count.index + 1}.txt"        # 1, 2, 3
  content  = "I am server ${count.index + 1}"
}

# Access one instance
local_file.server[0].filename   # first file

# Access all instances
local_file.server[*].filename   # list of all filenames
```

---

## Step-by-Step

**Step 1** - Apply and see what gets created:

```bash
cd 12-loops-count
terraform init
terraform apply
ls *.txt
```

**Step 2** - Read the output files:

```bash
cat server-1.txt
cat server-2.txt
cat server-3.txt
```

**Step 3** - See the outputs:

```bash
terraform output
terraform output server_filenames
```

**Step 4** - Change the count and reapply:

```bash
terraform apply -var="file_count=6"
ls log-*.txt
```

**Step 5** - Reduce the count:

```bash
terraform apply -var="file_count=2"
ls log-*.txt
```

Notice Terraform destroyed the extra files. This is how count works: Terraform always adjusts to match the number you specify.

**Step 6** - Clean up:

```bash
terraform destroy
```

---

## When to Use count vs for_each

Use `count` when:
- You want N identical (or numerically indexed) resources
- The number of resources is all that varies

Use `for_each` (Lab 13) when:
- Each resource has a unique name or identity
- You might add or remove items from the middle of the list

---

## Challenge

Change the server resource to create files named after server roles instead of numbers: `web-server.txt`, `api-server.txt`, `db-server.txt`. Hint: use a list and `count.index` to index into it.
