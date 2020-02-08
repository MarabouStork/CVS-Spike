resource "null_resource" "create_vehicle_events_service_bus" {

    triggers = {
        service_bus_name = var.vehicle_events_bus_name
    }

    provisioner "local-exec" {
        command = "aws events create-event-bus --name ${self.triggers.service_bus_name}"
    }

    provisioner "local-exec" {
        when = destroy
        command = "aws events delete-event-bus --name ${self.triggers.service_bus_name}"
    }
}




# resource "aws_lambda_function" "check_foo" {
#     filename = "check_foo.zip"
#     function_name = "checkFoo"
#     role = "arn:aws:iam::424242:role/something"
#     handler = "index.handler"
# }

# resource "aws_cloudwatch_event_rule" "every_five_minutes" {
#     name = "every-five-minutes"
#     description = "Fires every five minutes"
#     schedule_expression = "rate(5 minutes)"
# }

# resource "aws_cloudwatch_event_target" "check_foo_every_five_minutes" {
#     rule = "${aws_cloudwatch_event_rule.every_five_minutes.name}"
#     target_id = "check_foo"
#     arn = "${aws_lambda_function.check_foo.arn}"
# }

# resource "aws_lambda_permission" "allow_cloudwatch_to_call_check_foo" {
#     statement_id = "AllowExecutionFromCloudWatch"
#     action = "lambda:InvokeFunction"
#     function_name = "${aws_lambda_function.check_foo.function_name}"
#     principal = "events.amazonaws.com"
#     source_arn = "${aws_cloudwatch_event_rule.every_five_minutes.arn}"
# }