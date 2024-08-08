#DynamoDB table creation

resource "aws_dynamodb_table" "visitor_count_table" {
  name           = var.dynamodb_name
  billing_mode   = "PAY_PER_REQUEST"
  hash_key       = "key"

  attribute {
	name = "key"
	type = "S"
  }

  attribute {
	name = "counter"
	type = "N"
  }

  tags = {
	Name = "visitor_count_table"
  }
}


