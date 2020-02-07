
resource "aws_lambda_function" "test_results" {
    function_name = "test-results"

    # The bucket name as created earlier with "aws s3api create-bucket"
    s3_bucket = "${var.app_name}-backend"
    s3_key    = "v1.0.0/test-results.zip"

    # "main" is the filename within the zip file (main.js) and "handler"
    # is the name of the property under which the handler function was
    # exported in that file.
    handler = "main.handler"
    runtime = "nodejs10.x"

    role = aws_iam_role.lambda_exec.arn
}

# IAM role which dictates what other AWS services the Lambda function may access.
resource "aws_iam_role" "lambda_exec" {
    name = "${var.app_name}-backend"

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
    }]
}
EOF
}