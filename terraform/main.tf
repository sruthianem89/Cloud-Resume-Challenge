terraform {
  required_providers {
	aws = {
	  source  = "hashicorp/aws"
	  version = ">= 5.32.0"
	}
  }

  backend "s3" {
	bucket         = var.state_name
	key            = "terraform.tfstate"
	region         = "us-east-1"
  }
}

provider "aws" {
  region = var.region_name
}





