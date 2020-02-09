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