terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.0"
    }
  }
}

provider "aws" {
  region = var.region_name
}

resource "aws_s3_bucket" "frontend_bucket" {
  bucket = var.bucket_name
}

resource "aws_s3_bucket_website_configuration" "frontend_bucket_website" {
  bucket = aws_s3_bucket.frontend_bucket.bucket

  index_document {
  suffix = "index.html"
  }

  error_document {
  key = "index.html"
  }
}

resource "aws_s3_object" "index_html" {
  bucket = aws_s3_bucket.frontend_bucket.bucket
  key    = "index.html"
  source = "frontend/index.html"
  etag   = filemd5("frontend/index.html")
}


resource "aws_s3_object" "styles_css" {
  bucket = aws_s3_bucket.frontend_bucket.bucket
  key    = "css/styles.css"
  source = "frontend/css/styles.css"
  etag   = filemd5("frontend/css/styles.css")
}

resource "aws_s3_object" "scripts_js" {
  bucket = aws_s3_bucket.frontend_bucket.bucket
  key    = "js/scripts.js"
  source = "frontend/js/scripts.js"
  etag   = filemd5("frontend/js/scripts.js")
}


resource "aws_s3_bucket_policy" "frontend_bucket_policy" {
  bucket = aws_s3_bucket.frontend_bucket.id

  policy = jsonencode({
	Version = "2012-10-17"
	Statement = [
	  {
		Effect = "Allow"
		Principal = "*"
		Action = "s3:GetObject"
		Resource = "${aws_s3_bucket.frontend_bucket.arn}/*"
	  }
	]
  })
}

output "website_url" {
  value = aws_s3_bucket.frontend_bucket.website_endpoint
}