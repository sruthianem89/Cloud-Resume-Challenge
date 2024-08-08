# Zip Lambda function code
resource "null_resource" "zip_lambda_function_code" {
  provisioner "local-exec" {
	command = "cd ../backend && zip -r ../lambda_function.zip lambda_function.py"
  }

  # Ensure the zip is created before the Lambda function
  triggers = {
	always_run = "${timestamp()}"
  }
}

# Define the Lambda function for incrementing the counter
resource "aws_lambda_function" "frontend_lambda" {
  function_name = var.lambda_name
  filename      = "${path.module}/../lambda_function.zip"
  handler       = "lambda_function.lambda_handler"
  runtime       = var.lambda_runtime
  role          = aws_iam_role.lambda_role.arn

  # Pass the DynamoDB table name and Lambda function URL as environment variables
  environment {
    variables = {
      DYNAMODB_TABLE_NAME = aws_dynamodb_table.visitor_count_table.name
    }
  }

  # Ensure the Lambda function is created after the zip file and the initialize_lambda function
  depends_on = [
	null_resource.zip_lambda_function_code,
	aws_dynamodb_table.visitor_count_table,
	aws_lambda_function.initialize_lambda,
	aws_lambda_function_url.initialize_lambda_url
  ]
}

# Enable function URL and CORS
resource "aws_lambda_function_url" "frontend_lambda_url" {
  function_name      = aws_lambda_function.frontend_lambda.function_name
  authorization_type = "NONE"

  cors {
	allow_origins = ["*"]
  }

  # Ensure the function URL is created after the frontend_lambda function
  depends_on = [aws_lambda_function.frontend_lambda]
}

# Define the DynamoDB table
resource "aws_dynamodb_table" "visitor_count_table" {
  name           = "VisitorCountTable"
  billing_mode   = "PAY_PER_REQUEST"
  hash_key       = "ID"

  attribute {
	name = "ID"
	type = "S"
  }
}

# Define the Lambda function for initialization (example)
resource "aws_lambda_function" "initialize_lambda" {
  function_name = "initialize_lambda"
  filename      = "${path.module}/../initialize_lambda_function.zip"
  handler       = "initialize_lambda_function.lambda_handler"
  runtime       = var.lambda_runtime
  role          = aws_iam_role.lambda_role.arn

  # Ensure the Lambda function is created after the zip file
  depends_on = [
	null_resource.zip_initialize_lambda_function_code
  ]
}

# Zip Lambda function code for initialization (example)
resource "null_resource" "zip_initialize_lambda_function_code" {
  provisioner "local-exec" {
	command = "cd ../backend && zip -r ../initialize_lambda_function.zip initialize_lambda_function.py"
  }

  # Ensure the zip is created before the Lambda function
  triggers = {
	always_run = "${timestamp()}"
  }
}

# Enable function URL and CORS for initialization Lambda (example)
resource "aws_lambda_function_url" "initialize_lambda_url" {
  function_name      = aws_lambda_function.initialize_lambda.function_name
  authorization_type = "NONE"

  cors {
	allow_origins = ["*"]
  }

  # Ensure the function URL is created after the initialize_lambda function
  depends_on = [aws_lambda_function.initialize_lambda]
}