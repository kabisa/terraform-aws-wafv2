# terraform-aws-wafv2
This module enables WAFv2 on AWS. 
The following parameters are needed:
- `scope` For protecting a cloudfront distrubution pick `CLOUDFRONT` or `REGIONAL` for protecting a regional load balancer.
- `acl_name` The name of the WAF access control list.

The example folder contains, well an example.
