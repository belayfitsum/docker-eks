##########################################################
# Create IAM user and policies for contionous Deploy (CD) #
##########################################################

resource "aws_iam_user" "cd" {
  name = "simple-web-app-usr"
}

resource "aws_iam_access_key" "cd" {
  user = aws_iam_user.cd.name
}

##########################################################
# Policy for Terraform backend to S3 and Dynamo Db access #
##########################################################

data "aws_iam_policy_document" "tf_backend" {
  statement {
    effect    = "Allow"
    actions   = [
        "s3:ListBucket",
        "s3:GetBucketLocation"
        ]
    resources = ["arn:aws:s3:::${var.tf_state_bucket}"]
  }

  statement {
    effect = "Allow"
    actions = [ "s3:GetObject", "s3:PutObject", "s3:DeleteObject", "s3:HeadObject" ]
    resources = [ "arn:aws:s3:::${var.tf_state_bucket}/infra.tfstate/*" ]
  }

  statement {
    effect = "Allow"
    actions = [
      "dynamodb:DescribeTable",
      "dynamodb:GetItem",
      "dynamodb:PutItem",
      "dynamodb:DeleteItem",
      "dynamodb:UpdateItem"
    ]
    resources = ["arn:aws:dynamodb:*:*:table/${var.tf_state_lock_table}"]
  }

}

resource "aws_iam_policy" "tf_backend" {
  name        = "${aws_iam_user.cd.name}-tf-s3-dynamodb"
  description = "Allow user to use s3 and DynamoDb for TF backend resources"
  policy      = data.aws_iam_policy_document.tf_backend.json

}

resource "aws_iam_user_policy_attachment" "tf-backend" {
  user       = aws_iam_user.cd.name
  policy_arn = aws_iam_policy.tf_backend.arn

}

# data "aws_caller_identity" "current" {}

# resource "aws_s3_bucket_policy" "tf_backend" {
#   bucket = var.tf_state_bucket

#   policy = jsonencode({
#     Version = "2012-10-17"
#     Statement = [
#       {
#         Effect = "Allow"
#         Principal = {
#           AWS = "arn:aws:iam::${data.aws_caller_identity.current.account_id}:user/${aws_iam_user.cd.name}"
#         }
#         Action = [
#           "s3:GetObject",
#           "s3:PutObject",
#           "s3:DeleteObject",
#           "s3:ListBucket",
#           "s3:GetBucketLocation",
#           "s3:HeadObject"
#         ]
#         Resource = [
#           "arn:aws:s3:::${var.tf_state_bucket}",
#           "arn:aws:s3:::${var.tf_state_bucket}/*"
#         ]
#       }
#     ]
#   })
# }

