terraform {
  backend "s3" {
    bucket = "varsan-terraform-state"
    key    = "terraform.tfstate"
    region = "us-east-1"
  }
}
