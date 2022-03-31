{
  "Id": "SourceIP",
  "Version": "2012-10-17",
  "Statement": [
    {
      "Sid": "SourceIP",
      "Action": "s3:*",
      "Effect": "Deny",
      "Resource": [
        "arn:aws:s3:::hsbc-kpr",
        "arn:aws:s3:::hsbc-kpr/*"
      ],
      "Condition": {
        "NotIpAddress": {
          "aws:SourceIp": [
            "34.90.90.90"
          ]
        }
      },
      "Principal": "*"
    }
  ]
}