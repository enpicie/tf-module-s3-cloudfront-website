module "s3_website" {
  source       = "./modules/s3-static-website"
  bucket_name  = var.website_name
  source_files = var.source_files
  common_tags  = var.common_tags
}

module "cloudfront" {
  source                = "./modules/cloud-front"
  s3_bucket_id          = module.s3_website.static_website_id
  s3_bucket_domain_name = module.s3_website.static_website_regional_domain_name
  naming_prefix         = var.website_name
  common_tags           = var.common_tags
}

module "s3_cf_policy" {
  source                      = "./modules/s3-cf-policy"
  bucket_id                   = module.s3_website.static_website_id
  bucket_arn                  = module.s3_website.static_website_arn
  cloudfront_distribution_arn = module.cloudfront.cloudfront_distribution_arn
}
