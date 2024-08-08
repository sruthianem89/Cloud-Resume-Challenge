#depends on dynamodb table creation

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

  # Ensure the policy attachment is created after the IAM role
  depends_on = [aws_iam_role.lambda_role]
}

# Zip Lambda function code
resource "null_resource" "zip_initialize_dynamodb" {
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


  # Ensure the Lambda function is created after the zip file and DynamoDB table
  depends_on = [
	null_resource.zip_initialize_dynamodb,
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