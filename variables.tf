variable "acl_name" {
  type        = string
  description = "Name of the Access Control List"
}

variable "scope" {
  type        = string
  default     = "CLOUDFRONT"
  description = "Scope of the Access Control List, can be CLOUDFRONT or REGIONAL. If CLOUDFRONT is picked the region provider should be set to us-east-1"
}

variable "http_body_max_size" {
  type        = number
  default     = 16384
  description = "Size of the HTTP body, If this is larger then WAF inspection size it can result in not the entire body being inspected by WAF thus allowing malicious content to pass through"
}
