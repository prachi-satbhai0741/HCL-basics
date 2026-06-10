# 09 - Outputs

![Terraform](https://img.shields.io/badge/terraform-%3E%3D1.5-623CE4?logo=terraform&logoColor=white)
![Provider](https://img.shields.io/badge/provider-local%20%7C%20random-gray)
![AWS Required](https://img.shields.io/badge/AWS-not%20required-success)
![Difficulty](https://img.shields.io/badge/difficulty-beginner-brightgreen)
![Concept](https://img.shields.io/badge/concept-outputs-blue)

---

## What You Learn

- Declaring `output` blocks to expose values after apply
- Why outputs are used: reading values in CI/CD, passing between modules
- `sensitive = true` to hide secrets from logs
- Map outputs to group related values

---

## Step-by-Step

**Step 1** - Apply:

```bash
cd 09-outputs
terraform init
terraform apply
```

**Step 2** - See all outputs:

```bash
terraform output
```

Notice `app_secret` is listed as `(sensitive value)`.

**Step 3** - Get one output:

```bash
terraform output app_id
terraform output server_name
terraform output app_url
```

**Step 4** - See the sensitive output:

```bash
terraform output app_secret
```

**Step 5** - Get JSON (how CI/CD scripts consume outputs):

```bash
terraform output -json
terraform output -json app_summary
```

**Step 6** - Use an output in a shell script:

```bash
APP_URL=$(terraform output -raw app_url)
echo "Deployed to: $APP_URL"
```

**Step 7** - Clean up:

```bash
terraform destroy
```

---

## Challenge

Add an output called `app_id_decimal` that exposes `random_id.app_id.dec` (the decimal format of the ID).
