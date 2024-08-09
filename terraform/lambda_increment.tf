# Zip Lambda function code
resource "null_resource" "zip_lambda_function_code" {
  provisioner "local-exec" {
	command = "cd ../backend && rm -f ../terraform/lambda_function.zip && zip -r ../terraform/lambda_function.zip initialize_dynamodb.py"
  }

  # Ensure the zip is created before the Lambda function
#  triggers = {
#	always_run = "${timestamp()}"
#  }
}

# Define the Lambda function for incrementing the counter
resource "aws_lambda_function" "frontend_lambda" {
  function_name = var.lambda_name
  filename      = "../terraform/lambda_function.zip"
  handler       = "lambda_function.lambda_handler"
  runtime       = var.lambda_runtime
  role          = aws_iam_role.lambda_role.arn
  source_code_hash = filebase64sha256("../terraform/lambda_function.zip")

  # Ensure the Lambda function is created after the zip file
  depends_on = [
	null_resource.zip_lambda_function_code
  ]
}

# Enable function URL and CORS
resource "aws_lambda_function_url" "frontend_lambda_url" {
  function_name      = aws_lambda_function.frontend_lambda.function_name
  authorization_type = "NONE"

  cors {
	allow_origins = ["*"]
  allow_methods = ["*"]  # Include all methods
  allow_headers = ["Content-Type"]            # Include Content-Type
  }

  # Ensure the function URL is created after the frontend_lambda function
  depends_on = [aws_lambda_function.frontend_lambda]
}