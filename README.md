# tf-module-s3-cloudfront-website

Terraform module that deploys a static website (e.g. a React/Vite app) to AWS S3 with a CloudFront distribution as the frontend.

Derived from [Collin Smith's Medium post](https://collin-smith.medium.com/creating-a-simple-vite-react-front-end-application-hosted-in-s3-and-cloudfront-with-terraform-0526479502e3) on this architecture.

---

## Architecture

```
Browser → CloudFront (HTTPS) → S3 (private bucket)
```

- S3 bucket is fully private — no public access
- CloudFront uses Origin Access Control (OAC) to authenticate requests to S3
- An S3 bucket policy scoped to the CloudFront distribution ARN allows CloudFront read access
- 403 responses are redirected to `index.html` so client-side routers (e.g. React Router) work correctly

---

## Usage

```hcl
module "website" {
  source = "path/to/tf-module-s3-cloudfront-website"

  website_name = "my-react-app"
  source_files = "./dist"

  common_tags = {
    Project     = "my-react-app"
    Environment = "production"
  }
}

output "url" {
  value = module.website.cloudfront_domain_name
}
```

Build your app first, then run Terraform:

```bash
npm run build          # or: yarn build / pnpm build
terraform init
terraform apply
```

---

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|----------|
| `website_name` | Name used for the S3 bucket and as a naming prefix for all resources | `string` | — | yes |
| `source_files` | Path to the static website build output directory (e.g. `./dist`) | `string` | — | yes |
| `common_tags` | Tags to apply to all resources | `map(string)` | `{}` | no |
| `domain_name` | Custom domain name (e.g. `app.example.com`). Required if `acm_certificate_arn` is set. | `string` | `null` | no |
| `acm_certificate_arn` | ACM certificate ARN for the custom domain. **Must be in `us-east-1`** regardless of your stack region. | `string` | `null` | no |

---

## Outputs

| Name | Description |
|------|-------------|
| `cloudfront_domain_name` | CloudFront distribution domain (`*.cloudfront.net`) |
| `cloudfront_hosted_zone_id` | CloudFront hosted zone ID — use for Route53 alias records |
| `cloudfront_distribution_arn` | CloudFront distribution ARN |
| `s3_bucket_id` | S3 bucket name |
| `s3_bucket_arn` | S3 bucket ARN |

---

## Connecting a Route53 hosted zone (from another repo)

The ACM certificate must be created in `us-east-1` — this is a CloudFront constraint, not a general AWS requirement. CloudFront is a global service and only reads ACM certificates from the us-east-1 control plane, regardless of where your other resources are deployed. If your Route53 zone lives in a separate repo, the typical pattern is:

1. **Cert repo / DNS repo** — creates the ACM cert and validates it via Route53, then creates an alias record pointing to CloudFront
2. **This module** — receives the cert ARN as an input and configures CloudFront with the custom domain

```hcl
# In your DNS/Route53 repo — after applying this module and getting its outputs:

data "terraform_remote_state" "website" {
  backend = "s3"
  config = {
    bucket = "my-tfstate-bucket"
    key    = "website/terraform.tfstate"
    region = "us-east-1"
  }
}

resource "aws_route53_record" "website" {
  zone_id = aws_route53_zone.main.zone_id
  name    = "app.example.com"
  type    = "A"

  alias {
    name                   = data.terraform_remote_state.website.outputs.cloudfront_domain_name
    zone_id                = data.terraform_remote_state.website.outputs.cloudfront_hosted_zone_id
    evaluate_target_health = false
  }
}
```

And pass the cert ARN back into this module:

```hcl
module "website" {
  source = "path/to/tf-module-s3-cloudfront-website"

  website_name        = "my-react-app"
  source_files        = "./dist"
  domain_name         = "app.example.com"
  acm_certificate_arn = aws_acm_certificate_validation.cert.certificate_arn
}
```

---

## Module structure

```
.
├── main.tf                          # Wires sub-modules together
├── variables.tf
├── outputs.tf
└── modules/
    ├── s3-static-website/           # S3 bucket + file upload
    ├── cloud-front/                 # CloudFront distribution + OAC
    └── s3-cf-policy/                # Bucket policy granting CloudFront access
```

---

## Requirements

| Name | Version |
|------|---------|
| terraform | >= 1.3 |
| aws | >= 5.0 |
