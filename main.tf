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

resource "aws_cloudwatch_log_group" "rules" {
  name = "aws-waf-logs-rules-${var.acl_name}"
}

resource "aws_wafv2_web_acl_logging_configuration" "rules" {
  resource_arn            = aws_wafv2_web_acl.rules.arn
  log_destination_configs = [aws_cloudwatch_log_group.rules.arn]
}

resource "aws_cloudwatch_log_resource_policy" "rules" {
  policy_document = data.aws_iam_policy_document.rules.json
  policy_name     = "webacl-policy-${var.acl_name}"
}

data "aws_iam_policy_document" "rules" {
  version = "2012-10-17"
  statement {
    effect = "Allow"
    principals {
      identifiers = ["delivery.logs.amazonaws.com"]
      type        = "Service"
    }
    actions   = ["logs:CreateLogStream", "logs:PutLogEvents"]
    resources = ["${aws_cloudwatch_log_group.rules.arn}:*"]
    condition {
      test     = "ArnLike"
      values   = ["arn:aws:logs:${data.aws_region.current.name}:${data.aws_caller_identity.current.account_id}:*"]
      variable = "aws:SourceArn"
    }
    condition {
      test     = "StringEquals"
      values   = [tostring(data.aws_caller_identity.current.account_id)]
      variable = "aws:SourceAccount"
    }
  }
}

data "aws_region" "current" {}

data "aws_caller_identity" "current" {}
