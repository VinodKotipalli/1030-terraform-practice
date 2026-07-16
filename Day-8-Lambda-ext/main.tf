
##############################
# S3 Bucket
##############################

resource "aws_s3_bucket" "my_bucket" {
  bucket = "vinod22-lambda-bucket-123456"

  tags = {
    Name = "Lambda Bucket"
  }
}

##############################
# IAM Role
##############################

resource "aws_iam_role" "terraform_lam_role" {

  name = "terraform-lam-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"

    Statement = [
      {
        Effect = "Allow"

        Principal = {
          Service = "lambda.amazonaws.com"
        }

        Action = "sts:AssumeRole"
      }
    ]
  })
}

##############################
# IAM Policy Attachment
##############################

resource "aws_iam_role_policy_attachment" "lambda_basic_execution" {

  role = aws_iam_role.terraform_lam_role.name

  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole"
}

##############################
# Lambda Function
##############################

resource "aws_lambda_function" "terraform_lam" {

  function_name = "terraform-lambda"

  role = aws_iam_role.terraform_lam_role.arn

  runtime = "python3.12"

  handler = "lambda_function.lambda_handler"

  filename = "lambda_function.zip"

  source_code_hash = filebase64sha256("lambda_function.zip")
}

##############################
# EventBridge Rule
##############################

resource "aws_cloudwatch_event_rule" "terraform-lam-rule" {

  name                = "terraform-lam-rule"

  schedule_expression = "rate(5 minutes)"
}

##############################
# Event Target
##############################

resource "aws_cloudwatch_event_target" "lam-tag" {

  rule = aws_cloudwatch_event_rule.terraform-lam-rule.name

  target_id = "LambdaTarget"

  arn = aws_lambda_function.terraform_lam.arn
}

##############################
# Lambda Permission
##############################

resource "aws_lambda_permission" "allow_cloudwatch" {

  statement_id = "AllowExecutionFromCloudWatch"

  action = "lambda:InvokeFunction"

  function_name = aws_lambda_function.terraform_lam.function_name

  principal = "events.amazonaws.com"

  source_arn = aws_cloudwatch_event_rule.terraform-lam-rule.arn
}