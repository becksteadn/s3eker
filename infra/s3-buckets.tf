resource "aws_s3_bucket" "buckets" {
    bucket  = "s3eker-buckets"
    acl     = "private"
}

resource "aws_iam_policy" "buckets-write" {
    name = "s3eker-s3-buckets-write"
    description = "Allows writing to S3 bucket used for storing bucket domains."
    policy = <<EOF
    {
    "Id": "Policy1592752777775",
    "Version": "2012-10-17",
    "Statement": [
        {
        "Sid": "Stmt1592752776654",
        "Action": [
            "s3:PutObject"
        ],
        "Effect": "Allow",
        "Resource": "${aws_s3_bucket.buckets.arn}/*",
        "Principal": "*"
        }
    ]
    }
    EOF
}

resource "aws_iam_policy" "buckets-read" {
    name = "s3eker-s3-buckets-write"
    description = "Allows reading S3 bucket used for storing bucket domains."
    policy = <<EOF
    {
    "Id": "Policy1592752777774",
    "Version": "2012-10-17",
    "Statement": [
        {
        "Sid": "Stmt1592752776653",
        "Action": [
            "s3:GetObject"
        ],
        "Effect": "Allow",
        "Resource": "${aws_s3_bucket.buckets.arn}/*",
        "Principal": "*"
        }
    ]
    }
    EOF
}