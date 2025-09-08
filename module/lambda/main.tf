data "archive_file" "lambda_zip" {
  type        = "zip"
  source_dir  = "${path.module}/PythonCode/MyPython"
  output_path = "${path.module}/PythonCode/MyPython.zip"
}


resource "aws_lambda_function" "my_lambda_function" {
  filename         = data.archive_file.lambda_zip.output_path
  source_code_hash = data.archive_file.lambda_zip.output_base64sha256
  function_name    = "MyLambdaFunction"
  role             = var.role_arn
  handler          = "lambda_function.lambda_handler"
  runtime          = "python3.8"
  environment {
    variables = {
      ENV_VAR1 = "value1"
      ENV_VAR2 = "value2"
    }
  }

  tags = {
    Name        = "MyLambdaFunction"
    Environment = "dev"
  }

}


resource "aws_cloudwatch_log_group" "weekly__run_log_group" {
  name              = "/aws/lambda/${aws_lambda_function.my_lambda_function.function_name}"
  retention_in_days = 7
}