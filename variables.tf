variable "acl_name" {
  type        = string
  description = "Name of the Access Control List"
}

variable "scope" {
  type        = string
  default = "CLOUDFRONT"
  description = "Scope of the Access Control List, can be CLOUDFRONT or REGIONAL. If CLOUDFRONT is picked the region provider should be set to us-east-1"
}
