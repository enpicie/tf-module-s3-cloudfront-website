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

---

## Outputs

| Name | Description |
|------|-------------|
| `cloudfront_domain_name` | CloudFront distribution domain — use this as your website URL |
| `cloudfront_distribution_arn` | CloudFront distribution ARN |
| `s3_bucket_id` | S3 bucket name |
| `s3_bucket_arn` | S3 bucket ARN |

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
