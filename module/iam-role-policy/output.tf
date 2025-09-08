output "aws_lambda_role_arn" {
  description = "The ARN of the IAM role for Lambda execution"
  value       = aws_iam_role.example.arn
}
