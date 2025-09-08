output "weekly_run_lambda_function_arn" {
  description = "The ARN of the weekly run Lambda function"
  value       = aws_lambda_function.my_lambda_function.arn

}
