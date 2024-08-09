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
  filename      = "../lambda_function.zip"
  handler       = "lambda_function.lambda_handler"
  runtime       = var.lambda_runtime
  role          = aws_iam_role.lambda_role.arn

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
  }

  # Ensure the function URL is created after the frontend_lambda function
  depends_on = [aws_lambda_function.frontend_lambda]
}