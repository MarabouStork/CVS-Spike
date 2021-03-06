resource "aws_s3_bucket" "staging_test_results" {
    bucket = var.staging_bucket_test_results
    acl    = "private"

    # lifecycle {
    #     prevent_destroy = true
    # }
}

resource "aws_s3_bucket_public_access_block" "staging_test_results_public_block" {
  bucket = aws_s3_bucket.staging_test_results.id

  block_public_acls   = true
  block_public_policy = true
}

resource "aws_lambda_function" "event_completed_tests_stage_data" {
    function_name = "${var.app_name}-vehicleEvents-completedTest-stageData"

    # The bucket name as created earlier with "aws s3api create-bucket"
    s3_bucket = "${var.app_name}-backend"
    s3_key    = "v1.0.0/event.completed-tests.stage-data.zip"

    # "main" is the filename within the zip file (main.js) and "handler"
    # is the name of the property under which the handler function was
    # exported in that file.
    handler = "main.handler"
    runtime = "nodejs10.x"

    role = aws_iam_role.vehicle_events_role.arn
}

# The Lambda function needs write permissions to the S3 bucket
resource "aws_iam_role_policy" "allow_completed_test_s3_write" {
  name = "${aws_iam_role.vehicle_events_role.name}-s3-policy"
  role = aws_iam_role.vehicle_events_role.id

  policy = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
    {
        "Effect": "Allow",
        "Action": [
            "s3:PutObject"
        ],
        "Resource": ["${aws_s3_bucket.staging_test_results.arn}/*"]
    }]
}
EOF
}

## Give the rule permissions to invoke this lambda function
resource "aws_lambda_permission" "allow_completed_test_target1_execution" {
  function_name = aws_lambda_function.event_completed_tests_stage_data.function_name
  statement_id  = "AllowExecutionFromCompletedTestRule"
  action        = "lambda:InvokeFunction"
  principal     = "events.amazonaws.com"
  source_arn    = local.completed_vehicle_test_rule_data.RuleArn
}

## Attach the completed test rule to the above lambda through a new event target
resource "null_resource" "create_vehicle_events_completed_test_target1" {
    
    triggers = {
        service_bus_name = var.vehicle_events_bus_name
        rule_name        = var.vehicle_events_completed_tests_rule_name
        target_id        = "${var.vehicle_events_completed_tests_rule_name}.stageData.target"
        target_arn       = aws_lambda_function.event_completed_tests_stage_data.arn
    }

    provisioner "local-exec" {
        command = "aws events put-targets --rule ${self.triggers.rule_name} --event-bus-name ${self.triggers.service_bus_name} --targets [{\"Id\":\"${self.triggers.target_id}\",\"Arn\":\"${self.triggers.target_arn}\"}]"
    }

    provisioner "local-exec" {
        when = destroy
        command = "aws events remove-targets --rule ${self.triggers.rule_name} --event-bus-name ${self.triggers.service_bus_name} --ids ${self.triggers.target_id}"
    }
    
    depends_on = [
        null_resource.completed_vehicle_test_rule,
        null_resource.create_vehicle_events_service_bus,
        aws_iam_role.vehicle_events_role
    ]   
}
