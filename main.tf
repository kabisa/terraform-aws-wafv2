resource "aws_wafv2_web_acl" "rules" {
  provider = aws.us-east-1
  name     = var.acl_name
  scope    = var.scope
  default_action {
    allow {}
  }

  visibility_config {
    cloudwatch_metrics_enabled = true
    metric_name                = "RulesWafWebAcl"
    sampled_requests_enabled   = true
  }

  rule {
    name     = "CommonRuleSet"
    priority = 1
    statement {
      managed_rule_group_statement {
        name        = "AWSManagedRulesCommonRuleSet"
        vendor_name = "AWS"
      }
    }
    visibility_config {
      cloudwatch_metrics_enabled = true
      metric_name                = "CommonRuleSet"
      sampled_requests_enabled   = true
    }
    override_action {
      count {}
    }
  }

  rule {
    name     = "SQLiRuleSet"
    priority = 2
    statement {
      managed_rule_group_statement {
        name        = "AWSManagedRulesSQLiRuleSet"
        vendor_name = "AWS"
      }
    }
    visibility_config {
      cloudwatch_metrics_enabled = true
      metric_name                = "SQLiRuleSet"
      sampled_requests_enabled   = true
    }
    override_action {
      count {}
    }
  }

  rule {
    name     = "SizeConstraint"
    priority = 3

    statement {
      size_constraint_statement {
        comparison_operator = "GT"
        field_to_match {
          body {}
        }
        size = var.http_body_max_size
        text_transformation {
          type     = "NONE"
          priority = 10
        }
      }
    }
    visibility_config {
      cloudwatch_metrics_enabled = true
      metric_name                = "SizeConstraint"
      sampled_requests_enabled   = true
    }
    action {
      count {}
    }
  }

  rule {
    name     = "KnownBadInputsRuleSet"
    priority = 4
    statement {
      managed_rule_group_statement {
        name        = "AWSManagedRulesKnownBadInputsRuleSet"
        vendor_name = "AWS"
      }
    }
    visibility_config {
      cloudwatch_metrics_enabled = true
      metric_name                = "KnownBadInputsRuleSet"
      sampled_requests_enabled   = true
    }
    override_action {
      count {}
    }
  }

  rule {
    name     = "AmazonIpReputationsList"
    priority = 5
    statement {
      managed_rule_group_statement {
        name        = "AWSManagedRulesAmazonIpReputationList"
        vendor_name = "AWS"
      }
    }
    visibility_config {
      cloudwatch_metrics_enabled = true
      metric_name                = "AmazonIpReputationsList"
      sampled_requests_enabled   = true
    }
    override_action {
      count {}
    }
  }
}
