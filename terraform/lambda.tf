
#lambda function creation

# Create IAM role for Lambda with full access to Amazon DynamoDB
resource "aws_iam_role" "lambda_role" {
  name = "lambda_execution_role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          Service = "lambda.amazonaws.com"
        }
      }
    ]
  })
}

# Attach the AmazonDynamoDBFullAccess policy to the IAM role
resource "aws_iam_role_policy_attachment" "lambda_dynamodb_policy" {
  role       = aws_iam_role.lambda_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonDynamoDBFullAccess"
}

# Zip Lambda function code
resource "null_resource" "zip_lambda_function_code" {
  provisioner "local-exec" {
    command = "cd ../backend && zip -r ../lambda_function.zip ."
  }

  # Ensure the zip is created before the Lambda function
  triggers = {
    always_run = "${timestamp()}"
  }
}

# Define the Lambda function
resource "aws_lambda_function" "frontend_lambda" {
  function_name = var.lambda_name
  filename      = "${path.module}/../lambda_function.zip"
  handler       = "lambda_function.lambda_handler"
  runtime       = var.lambda_runtime
  role          = aws_iam_role.lambda_role.arn

  # Ensure the Lambda function is created after the zip file
  depends_on = [null_resource.zip_lambda_function_code]
}


# Enable function URL and CORS
resource "aws_lambda_function_url" "frontend_lambda_url" {
  function_name = aws_lambda_function.frontend_lambda.function_name
  authorization_type = "NONE"

  cors {
    allow_origins = ["*"]
  }
}