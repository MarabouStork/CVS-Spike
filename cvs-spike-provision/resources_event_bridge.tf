####################################################################################################
#                                                                                                  #
#                                 Create/Destroy Service Bus                                       #
#                                                                                                  #
####################################################################################################

data "template_file" "create_vehicle_events_service_bus" {
    template = "${path.module}/${var.aws_cli_output_folder}/create_vehicle_events_service_bus.json"
}

data "local_file" "create_vehicle_events_service_bus" {
    filename = "${data.template_file.create_vehicle_events_service_bus.rendered}"
    depends_on = [
        null_resource.create_vehicle_events_service_bus
    ]
}

resource "null_resource" "create_vehicle_events_service_bus" {
    
    triggers = {
        service_bus_name = var.vehicle_events_bus_name
    }

    provisioner "local-exec" {
        command = "aws events create-event-bus --name ${self.triggers.service_bus_name} > ${data.template_file.create_vehicle_events_service_bus.rendered}"
    }

    provisioner "local-exec" {
        when = destroy
        command = "aws events delete-event-bus --name ${self.triggers.service_bus_name}"
    }
    
    depends_on = [
        aws_iam_role.vehicle_events_role
    ]
}

####################################################################################################
#                                                                                                  #
#                            Create/Destroy Completed Test Rule                                    #
#                                                                                                  #
####################################################################################################

data "template_file" "completed_vehicle_test_rule" {
    template = "${path.module}/${var.aws_cli_output_folder}/completed_vehicle_test_rule.json"
}

data "local_file" "completed_vehicle_test_rule" {
    filename = "${data.template_file.completed_vehicle_test_rule.rendered}"
    depends_on = [
        null_resource.completed_vehicle_test_rule
    ]
}

# Create rule to react to the completion of vehicle tests
resource "null_resource" "completed_vehicle_test_rule" {
    
    triggers = {
        service_bus_name = var.vehicle_events_bus_name
        rule_name        = var.vehicle_events_completed_tests_rule_name
    }

    provisioner "local-exec" {
        command = "aws events put-rule --name ${self.triggers.rule_name} --event-bus-name ${self.triggers.service_bus_name} --event-pattern {\"source\":[\"ede-services.vehicletests\"],\"detail-type\":[\"completed-test\"]} --role-arn ${aws_iam_role.vehicle_events_role.arn} > ${data.template_file.completed_vehicle_test_rule.rendered}"
    }

    provisioner "local-exec" {
        when = destroy
        command = "aws events delete-rule --name ${self.triggers.rule_name} --event-bus-name ${self.triggers.service_bus_name}"
    }

    depends_on = [
        null_resource.create_vehicle_events_service_bus,
        aws_iam_role.vehicle_events_role
    ]
}

resource "aws_iam_role" "vehicle_events_role" {
    name = "${var.app_name}-vehicleEvents-role"

    assume_role_policy = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
    {
        "Effect": "Allow",
        "Action": "sts:AssumeRole",
        "Principal": {
            "Service": [
                "events.amazonaws.com", 
                "lambda.amazonaws.com"
            ]
        },
        "Sid": ""
    }]
}
EOF
}

locals {
  create_vehicle_events_service_bus_data = jsondecode(data.local_file.create_vehicle_events_service_bus.content)
  completed_vehicle_test_rule_data = jsondecode(data.local_file.completed_vehicle_test_rule.content)
}

output "create_vehicle_events_service_bus_arn" {
  value = local.create_vehicle_events_service_bus_data.EventBusArn  
}

output "completed_vehicle_test_rule_arn" {
  value = local.completed_vehicle_test_rule_data.RuleArn
}