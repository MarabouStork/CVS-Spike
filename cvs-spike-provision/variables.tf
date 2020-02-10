################################################
#              Miscelaneous Names              #
################################################
variable "app_name" {
    default = "cvs-spike" 
}

variable "data_repo_name" {
    default = "EDE"
} 

variable "data_repo_description" {
    default = "Enterprise Data Environment"
}

variable "region" {
    default = "eu-west-2"
}

################################################
#       Event Bridge Service Bus Settings      #
################################################
variable "vehicle_events_bus_name" {
    default = "EDE-vehicleEvents"
}

variable "vehicle_events_completed_tests_rule_name" {
    default = "EDE-vehicleEvents.completedTest"
}

variable "vehicle_events_completed_tests_rule_filter" {
    default = "{\"source\": [\"ede-services.vehicletests\"], \"detail-type\": [\"completed-test\"]}"
}

################################################
#            Data Staging Settings             #
################################################
variable "staging_bucket_test_results" {
    default = "staging-vehicle-test-results"
}


################################################
#                Path Settings                 #
################################################
variable "aws_cli_output_folder" {
    default = ".aws-cli-output"
}