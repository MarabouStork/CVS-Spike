# data "template_file" "create_vehicle_events_service_bus" {
#     template = "${path.module}/create_vehicle_events_service_bus_output.log"
# }

# data "local_file" "create_vehicle_events_service_bus" {
#     filename = "${data.template_file.create_vehicle_events_service_bus.rendered}"
#     depends_on = [
#         null_resource.query_vehicle_events_service_bus_arn
#     ]
# }

# Create and destroy the service bus using the AWS CLI (no Terra-Resource exists for this)
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

# # Assign permissions to put events to this service bus
# resource "null_resource" "permissions_vehicle_events_service_bus" {
    
#     triggers = {
#         service_bus_name = var.vehicle_events_bus_name
#         statement_id = "${var.vehicle_event_bus_name}:test_results"
#     }

#     provisioner "local-exec" {
#         command = "aws events put-permission --event-bus-name ${self.triggers.service_bus_name} --action \"events:PutEvents\"  --name ${self.triggers.service_bus_name} --principal \"lambda.amazonaws.com\"
#     }

#     provisioner "local-exec" {
#         when = destroy
#         command = "aws events delete-event-bus --name ${self.triggers.service_bus_name}"
#     }
# }




# # Used to query the service bus ARN
# resource "null_resource" "query_vehicle_events_service_bus_arn" {
     
#     provisioner "local-exec" {
#         command = "aws events list-event-buses --output text --query \"EventBuses[?Name=='EDE-vehicle-events'].Arn\" > ${data.template_file.create_vehicle_events_service_bus.rendered}"
#     }

#     depends_on = [
#         null_resource.create_vehicle_events_service_bus
#     ]
# }

# resource "aws_cloudwatch_event_permission" "test_results_permissions" {
#     statement_id    = "AllowVehicleTestResultsFunctionToRaiseEvents"
#     action          = "eventss:PutEvents"
     

# }

# resource "aws_lambda_permission" "lambda_permission" {
#   statement_id  = "AllowFunctionToVehicleTestResultsEvents"
#   action        = "events:PutEvents"
#   function_name = aws_lambda_function.test_results.function_name
#   principal     = "apigateway.amazonaws.com"

#   # The /*/*/* part allows invocation from any stage, method and resource path
#   # within API Gateway REST API.
#   source_arn = trimspace(data.local_file.create_vehicle_events_service_bus)

#   depends_on = [
#       null_reference.create_vehicle_events_service_bus
#   ]
# }





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