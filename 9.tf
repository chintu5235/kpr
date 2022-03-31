provider "aws" {
  region     = "ap-southeast-1"
  access_key = "AKIAWDPSHBWL4336HO2H"
  secret_key = "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"
}
resource "aws_iam_user" "kprash" {
  name = "prashanth"
  path = "/system/"

  tags = {
    tag-key = "tag-kpr"
  }
}

resource "aws_iam_access_key" "kp" {
  user = aws_iam_user.kprash.name
}

resource "aws_iam_user_policy" "chintu_kp" {
  name = "test"
  user = aws_iam_user.kprash.name

  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": [
        "ec2:Describe*"
      ],
      "Effect": "Allow",
      "Resource": "*"
    },
	    {
      "Action": [
        "ec2:route53*"
      ],
      "Effect": "Allow",
      "Resource": "*"
    }
  ]
}
EOF
}
