resource "aws_cloudwatch_event_rule" "weekly_run_rule" {
  name                = "weekly-run-rule"
  description         = "Triggers the weekly run event every Monday at 00:00 UTC"
  schedule_expression = "cron(0/3 * ? * * *)"
}

resource "aws_cloudwatch_event_target" "weekly_run_target" {
  rule      = aws_cloudwatch_event_rule.weekly_run_rule.name
  target_id = "weekly-run-target"
  arn       = var.weekly_run_lambda_function_arn

}

resource "aws_lambda_permission" "allow_cloudwatch_to_invoke_weekly_run" {
  statement_id  = "AllowExecutionFromCloudWatch"
  action        = "lambda:InvokeFunction"
  function_name = var.weekly_run_lambda_function_arn
  principal     = "events.amazonaws.com"
  source_arn    = aws_cloudwatch_event_rule.weekly_run_rule.arn
}
