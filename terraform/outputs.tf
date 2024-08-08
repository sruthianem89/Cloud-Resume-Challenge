output "website_url" {
  value = "http://${aws_s3_bucket.frontend_bucket.bucket}.s3-website-${var.region_name}.amazonaws.com"
}

output "lambda_function_url" {
  value = aws_lambda_function_url.frontend_lambda_url.function_url
}

output "dynamodb_table_name" {
  value = aws_dynamodb_table.visitor_count_table.name
}

output "initialize_dynamodb_url" {
  value = aws_lambda_function_url.initialize_lambda_url.function_url
}
