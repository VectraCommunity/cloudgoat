#IAM User
resource "aws_iam_user" "cg-chris-kp" {
  name = "${var.cg-chris-kp-name}-${var.cgid}"
  tags = {
    Name     = "cg-chris-kp"
    Stack    = "${var.stack-name}"
    Scenario = "${var.scenario-name}"
  }
}

resource "aws_iam_access_key" "cg-chris-kp" {
  user = aws_iam_user.cg-chris-kp.name
}

# IAM roles
resource "aws_iam_role" "cg-lambdaManager-role" {
  name = "lambdaManager-role"
  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Principal": {
        "AWS": "${aws_iam_user.cg-chris-kp.arn}"
      },
      "Effect": "Allow",
      "Sid": ""
    }
  ]
}
EOF
  tags = {
    Name = "cg-debug-role-${var.cgid}"
    Stack = "${var.stack-name}"
    Scenario = "${var.scenario-name}"
  }
}

resource "aws_iam_role" "cg-debug-role" {
  name = "admin-lambda-service-role"-${var.cgid}
  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Principal": {
        "Service": "lambda.amazonaws.com"
      },
      "Effect": "Allow",
      "Sid": ""
    }
  ]
}
EOF
  tags = {
    Name = "cg-debug-role-${var.cgid}"
    Stack = "${var.stack-name}"
    Scenario = "${var.scenario-name}"
  }
}

# IAM Policies
resource "aws_iam_policy" "cg-lambdaManager-policy" {
  name = "lambdaManager-policy"
  description = "cg-lambdaManager-policy-${var.cgid}"
  policy =<<EOF
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Sid": "lambdaManager",
            "Effect": "Allow",
            "Action": [
                "lambda:*",
                "iam:PassRole",
                "events:*"
            ],
            "Resource": "*"
        }
    ]
}
EOF
}

resource "aws_iam_policy" "chris-kp-policy" {
  name = "chris-kp-policy"-${var.cgid}
  description = "chris-kp-policy-${var.cgid}"
  policy =<<EOF
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Sid": "chris",
            "Effect": "Allow",
            "Action": [
                "sts:AssumeRole",
                "iam:List*",
                "iam:Get*"
            ],
            "Resource": "*"
        }
    ]
}
EOF
}

#Policy Attachments
resource "aws_iam_role_policy_attachment" "cg-debug-role-attachment" {
  role = aws_iam_role.cg-debug-role.name
  policy_arn = data.aws_iam_policy.administrator-full-access.arn
}

resource "aws_iam_role_policy_attachment" "cg-lambdaManager-role-attachment" {
  role = aws_iam_role.cg-lambdaManager-role.name
  policy_arn = aws_iam_policy.cg-lambdaManager-policy.arn
}

resource "aws_iam_user_policy_attachment" "cg-chris-kp-attachment" {
  user = aws_iam_user.cg-chris-kp.name
  policy_arn = aws_iam_policy.chris-kp-policy.arn
}