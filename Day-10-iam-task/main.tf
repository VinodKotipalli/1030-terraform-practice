# IAM User

resource "aws_iam_user" "user" {
  name = var.iam_user_name
 tags = {
    
  }
}


# IAM group

resource "aws_iam_group" "group" {
  name = var.iam_group_name
}


# Add User to Group

resource "aws_iam_user_group_membership" "membership" {
  user = aws_iam_user.user.name

  groups = [
    aws_iam_group.group.name
  ]
}


# Custom IAM Policy

resource "aws_iam_policy" "s3_readonly" {

  name = var.policy_name

  description = "Allow Read Only Access to S3"

  policy = jsonencode({

    Version = "2012-10-17"

    Statement = [

      {

        Effect = "Allow"

        Action = [

          "s3:GetObject",

          "s3:ListBucket"

        ]

        Resource = "*"

      }

    ]

  })
}


# Attach Policy to Group

resource "aws_iam_group_policy_attachment" "attach_policy" {

  group      = aws_iam_group.group.name

  policy_arn = aws_iam_policy.s3_readonly.arn

}


# EC2 Trust Policy

data "aws_iam_policy_document" "ec2_assume_role" {

  statement {

    actions = ["sts:AssumeRole"]

    principals {

      type = "Service"

      identifiers = ["ec2.amazonaws.com"]

    }

  }

}

# IAM Role

resource "aws_iam_role" "ec2_role" {

  name = var.iam_role_name 

  assume_role_policy = data.aws_iam_policy_document.ec2_assume_role.json

}

# Attach AWS Managed Policy


resource "aws_iam_role_policy_attachment" "ssm_policy" {

  role       = aws_iam_role.ec2_role.name

  policy_arn = "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"

}

# Instance Profile

resource "aws_iam_instance_profile" "profile" {

  name = var.instance_profile_name

  role = aws_iam_role.ec2_role.name

}