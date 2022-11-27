terraform {

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "4.26.0"
    }
  }

  backend "s3" {
    profile = "terraform-trabalho"
    bucket  = "bucket-trabalho"
    key     = "state/terraform.tfstate"
    region  = "us-east-1"
    encrypt = true
  }

}