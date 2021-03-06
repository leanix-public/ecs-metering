provider "archive" {}

data "archive_file" "zip" {
  type        = "zip"
  source_file = "${path.module}/ecs-chargeback.py"
  output_path = "${path.module}/ecs-chargeback.zip"

}


resource "aws_lambda_function" "chargeback" {
  function_name    = "compute-ecs-services-cost"
  role             = var.exec_role
  filename         = data.archive_file.zip.output_path
  source_code_hash = data.archive_file.zip.output_base64sha256
  handler          = "ecs-chargeback.lambda_handler"
  runtime          = "python3.7"
  timeout          = 30
  environment {
    variables = { 
      secret_name : var.name_secret,
      bucket_name: var.bucket_name
    }
  }
}

