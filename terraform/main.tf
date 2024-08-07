terraform {
  required_providers {
	aws = {
	  source  = "hashicorp/aws"
	  version = "~> 4.0"
	}
  }

  backend "s3" {
	bucket         = "terraformstatesru"
	key            = "path/to/your/terraform.tfstate"
	region         = "us-east-1"
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
  bucket       = aws_s3_bucket.frontend_bucket.bucket
  key          = "index.html"
  source       = "${path.module}/../frontend/index.html"
  etag         = filemd5("${path.module}/../frontend/index.html")
  content_type = "text/html"
}

resource "aws_s3_object" "styles_css" {
  bucket       = aws_s3_bucket.frontend_bucket.bucket
  key          = "css/styles.css"
  source       = "${path.module}/../frontend/css/styles.css"
  etag         = filemd5("${path.module}/../frontend/css/styles.css")
  content_type = "text/css"
}

resource "aws_s3_object" "scripts_js" {
  bucket       = aws_s3_bucket.frontend_bucket.bucket
  key          = "js/scripts.js"
  source       = "${path.module}/../frontend/js/scripts.js"
  etag         = filemd5("${path.module}/../frontend/js/scripts.js")
  content_type = "application/javascript"
}

resource "aws_s3_object" "profile_image" {
  bucket       = aws_s3_bucket.frontend_bucket.bucket
  key          = "images/profile.jpg"
  source       = "${path.module}/../frontend/images/profile.jpg"
  etag         = filemd5("${path.module}/../frontend/images/profile.jpg")
  content_type = "image/jpeg"
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

resource "aws_s3_bucket_public_access_block" "frontend_bucket_public_access_block" {
  bucket                  = aws_s3_bucket.frontend_bucket.id
  block_public_acls       = false
  block_public_policy     = false
  ignore_public_acls      = false
  restrict_public_buckets = false
}

output "website_url" {
  value = "http://${aws_s3_bucket.frontend_bucket.bucket}.s3-website-${var.region_name}.amazonaws.com"
}