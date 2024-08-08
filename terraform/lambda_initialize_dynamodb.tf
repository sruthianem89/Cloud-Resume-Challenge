#depends on dynamodb table creation

# Zip Lambda function code
resource "null_resource" "zip_lambda_function_code" {
  provisioner "local-exec" {
	command = "cd ../backend && zip -r ../initialize_dynamodb.zip initialize_dynamodb.py"
  }

  # Ensure the zip is created before the Lambda function
  triggers = {
	always_run = "${timestamp()}"
  }
}

# Define the Lambda function
resource "aws_lambda_function" "initialize_lambda" {
  function_name = var.lambda_initialize_dynamodb_name
  filename      = "${path.module}/../initialize_dynamodb.zip"
  handler       = "initialize_dynamodb.lambda_handler"
  runtime       = var.lambda_runtime
  role          = aws_iam_role.lambda_role.arn

  # Pass the DynamoDB table name as an environment variable
  environment {
    variables = {
      DYNAMODB_TABLE_NAME = aws_dynamodb_table.visitor_count_table.name
    }
  }

  # Ensure the Lambda function is created after the zip file and DynamoDB table
  depends_on = [
	null_resource.zip_lambda_function_code,
	aws_dynamodb_table.visitor_count_table
  ]
}

# Enable function URL and CORS
resource "aws_lambda_function_url" "initialize_lambda_url" {
  function_name       = aws_lambda_function.initialize_lambda.function_name
  authorization_type  = "NONE"

  cors {
	allow_origins = ["*"]
  }

  # Ensure the function URL is created after the Lambda function
  depends_on = [aws_lambda_function.initialize_lambda]
}