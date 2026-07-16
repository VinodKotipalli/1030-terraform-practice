terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 6.55"
    }
    archive = {
      source  = "hashicorp/archive"
      version = "~> 2.3"
    }
  }
}

resource "aws_iam_role" "lambda_role" {
  name = "lambda_execution_role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          Service = "lambda.amazonaws.com"
        }
      },
    ]
  })
}
#custom policy for lambda function
 resource "aws_iam_role_policy_attachment" "lambda_policy" {
  role = aws_iam_role.lambda_role.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole" #existing AWS managed policy for Lambda execution

}

data "archive_file" "lambda_zip" {
  type        = "zip"
  source_file = "${path.module}/lambda_function.py"
  output_path = "${path.module}/lambda_function.zip"
}

resource "aws_lambda_function" "my_lambda_function" {
  function_name    = "my_lambda_function"
  role             = aws_iam_role.lambda_role.arn
  runtime          = "python3.8"
  handler          = "lambda_function.lambda_handler"
  s3_bucket        = aws_s3_bucket.lambda_bucket.bucket
  s3_key           = aws_s3_object.lambda_zip.key
  timeout          = 900
  source_code_hash = filebase64sha256(data.archive_file.lambda_zip.output_path)
}

resource "aws_cloudwatch_event_rule" "lambda_schedule" {
  name                = "lambda_schedule_rule"
  description         = "Trigger Lambda on a schedule"
  schedule_expression = "cron(0/5 * * * ? *)"
}

resource "aws_cloudwatch_event_target" "lambda_schedule_target" {
  rule      = aws_cloudwatch_event_rule.lambda_schedule.name
  target_id = "lambda_schedule_target"
  arn       = aws_lambda_function.my_lambda_function.arn
}

resource "aws_lambda_permission" "allow_cloudwatch" {
  statement_id  = "AllowExecutionFromCloudWatch"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.my_lambda_function.function_name
  principal     = "events.amazonaws.com"
  source_arn    = aws_cloudwatch_event_rule.lambda_schedule.arn
}

resource "aws_lambda_permission" "allow_s3" {
  statement_id  = "AllowExecutionFromS3"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.my_lambda_function.function_name
  principal     = "s3.amazonaws.com"
  source_arn    = aws_s3_bucket.lambda_bucket.arn
}

resource "aws_s3_bucket" "lambda_bucket" {
  bucket = "vinod-lambda-code-bucket-12345"

  tags = {
    Name = "Lambda Code Bucket"
  }

}

resource "aws_s3_object" "lambda_zip" {
  bucket = aws_s3_bucket.lambda_bucket.id
  key    = "lambda_function.zip"
  source = data.archive_file.lambda_zip.output_path
  etag   = filemd5(data.archive_file.lambda_zip.output_path)
}