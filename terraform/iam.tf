##########################################################
# Create IAM user and policies for contionous Deploy (CD) #
##########################################################

# resource "aws_iam_user" "cd" {
#   name = "simple-web-app-usr"
# }

# resource "aws_iam_access_key" "cd" {
#   user = aws_iam_user.cd.name
# }

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
  name        = "simple-web-app-usr-tf-s3-dynamodb"
  description = "Allow user to use s3 and DynamoDb for TF backend resources"
  policy      = data.aws_iam_policy_document.tf_backend.json

}

resource "aws_iam_user_policy_attachment" "tf-backend" {
  user       = "simple-web-app-usr"
  policy_arn = aws_iam_policy.tf_backend.arn

}

#########################
# Policy for ECR access #
#########################

data "aws_iam_policy_document" "ecr" {
  statement {
    effect    = "Allow"
    actions   = ["ecr:GetAuthorizationToken"]
    resources = ["*"]
  }

  statement {
    effect = "Allow"
    actions = [
      "ecr:CompleteLayerUpload",
      "ecr:UploadLayerPart",
      "ecr:InitiateLayerUpload",
      "ecr:BatchCheckLayerAvailability",
      "ecr:PutImage"
    ]
    resources = [
       aws_ecr_repository.express_app_repo.arn
    ]
  }

  statement {
  effect = "Allow"
  actions = [
    "ecr:DescribeRepositories",
    "ecr:ListImages",
    "ecr:DescribeImages",
    "ecr:BatchGetImage",
    "ecr:GetDownloadUrlForLayer",
    "ecr:ListTagsForResource"
  ]
  resources = [
    aws_ecr_repository.express_app_repo.arn
  ]
}
}

resource "aws_iam_policy" "ecr" {
  name        = "simple-web-app-usr-ecr"
  description = "Allow user to manage ECR resources"
  policy      = data.aws_iam_policy_document.ecr.json
}

resource "aws_iam_user_policy_attachment" "ecr" {
  user       = "simple-web-app-usr"
  policy_arn = aws_iam_policy.ecr.arn
}

#########################
# Policy for K8 access #
#########################



