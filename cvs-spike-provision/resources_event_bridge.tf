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
    
    depends_on = [
        aws_iam_role.vehicle_events_role
    ]
}

# Create rule to react to the completion of vehicle tests
resource "null_resource" "completed_vehicle_test_rule" {
    
    triggers = {
        service_bus_name = var.vehicle_events_bus_name
        rule_name        = var.vehicle_events_completed_tests_rule_name
    }

    provisioner "local-exec" {
        command = "aws events put-rule --name ${self.triggers.rule_name} --event-bus-name ${self.triggers.service_bus_name} --event-pattern {\"source\":[\"ede-services.vehicletests\"],\"detail-type\":[\"completed-test\"]} --role-arn ${aws_iam_role.vehicle_events_role.arn}"
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

