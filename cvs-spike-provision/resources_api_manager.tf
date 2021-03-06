# Create a new file api_gateway.tf in the same directory as our lambda.tf from the previous step. First, configure 
# the root "REST API" object, as follows
resource "aws_api_gateway_rest_api" "cvs_backend" {
    name        = "${var.data_repo_name}-Services"
    description = "${var.data_repo_description} - Vehicle Services"
}


# All incoming requests to API Gateway must match with a configured resource and method in order to be handled. 
# Append the following to the lambda.tf file to define a single proxy resource
resource "aws_api_gateway_resource" "test_results" {
    rest_api_id = aws_api_gateway_rest_api.cvs_backend.id
    parent_id   = aws_api_gateway_rest_api.cvs_backend.root_resource_id
    path_part   = "test-results"
}

resource "aws_api_gateway_method" "test_results" {
    rest_api_id   = aws_api_gateway_rest_api.cvs_backend.id
    resource_id   = aws_api_gateway_resource.test_results.id
    http_method   = "POST"
    authorization = "NONE"
}

# Each method on an API gateway resource has an integration which specifies where incoming requests are routed. 
# Add the following configuration to specify that requests to this method should be sent to the Lambda function 
# defined earlier
resource "aws_api_gateway_integration" "test_results" {
    rest_api_id = aws_api_gateway_rest_api.cvs_backend.id
    resource_id = aws_api_gateway_method.test_results.resource_id
    http_method = aws_api_gateway_method.test_results.http_method

    integration_http_method = "POST"
    type                    = "AWS_PROXY"
    uri                     = aws_lambda_function.test_results.invoke_arn
}

# Finally, you need to create an API Gateway "deployment" in order to activate the configuration and expose 
# the API at a URL that can be used for testing
resource "aws_api_gateway_deployment" "example" {
    depends_on = [
        aws_api_gateway_integration.test_results,
        # aws_api_gateway_integration.test_results_root,
    ]

    rest_api_id = aws_api_gateway_rest_api.cvs_backend.id
    stage_name  = "test"
 }
