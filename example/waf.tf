module "waf" {
  source   = "github.com/kabisa/terraform-aws-wafv2"
  acl_name = "staging_acl"
  scope = "CLOUDFRONT"


  providers = {
    aws           = aws
    aws.us-east-1 = aws.us-east-1
  }
}