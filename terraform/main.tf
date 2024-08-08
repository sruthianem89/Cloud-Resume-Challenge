terraform {
  required_providers {
	aws = {
	  source  = "hashicorp/aws"
	  version = ">= 5.32.0"
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





