output "website_url" {
  value = "http://${aws_s3_bucket.frontend_bucket.bucket}.s3-website-${var.region_name}.amazonaws.com"
}

output "lambda_function_url" {
  value = aws_lambda_function_url.frontend_lambda_url.function_url
}