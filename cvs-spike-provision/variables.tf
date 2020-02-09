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

################################################
#       Event Bridge Service Bus Settings      #
################################################
variable "vehicle_events_bus_name" {
    default = "EDE-vehicle-events"
}

################################################
#            Data Staging Settings             #
################################################
variable "staging_bucket_test_results" {
    default = "staging-vehicle-test-results"
}
