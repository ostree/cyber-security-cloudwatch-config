variable "eu-west-1__lambda__Duration" {
  description = "List of metrics derived from aws cloudwatch list-metrics"
  type        = list
  default     = []
}

variable "eu-west-2__lambda__Duration" {
  description = "List of metrics derived from aws cloudwatch list-metrics"
  type        = list
  default     = []
}

resource "aws_cloudwatch_metric_alarm" "euw1_cloudwatch_lambda_duration" {
  # iterate over count to setup multiple alarms
  count               = length(var.eu-west-1__lambda__Duration)
  provider            = aws.eu-west-1
  alarm_name          = "${var.eu-west-1__lambda__Duration[count.index].ResourceName}_alarm"
  comparison_operator = "GreaterThanOrEqualToThreshold"
  evaluation_periods  = 1
  threshold           = var.eu-west-1__lambda__Duration[count.index].Threshold
  alarm_description   = "Tracks execution duration of lambda functions."
  metric_name         = "Duration"
  namespace           = "AWS/Lambda"
  period              = 300
  statistic           = "Maximum"
  dimensions = {
    FunctionName = var.eu-west-1__lambda__Duration[count.index].ResourceName
  }
  alarm_actions       = ["${local.euw1_sns_cloudwatch_forwarder_topic}"]
  ok_actions          = ["${local.euw1_sns_cloudwatch_forwarder_topic}"]
  treat_missing_data  = "notBreaching"
}

resource "aws_cloudwatch_metric_alarm" "euw2_cloudwatch_lambda_duration" {
  # iterate over count to setup multiple alarms
  count               = length(var.eu-west-2__lambda__Duration)
  provider            = aws.eu-west-2
  alarm_name          = "${var.eu-west-2__lambda__Duration[count.index].ResourceName}_alarm"
  comparison_operator = "GreaterThanOrEqualToThreshold"
  evaluation_periods  = 1
  threshold           = var.eu-west-2__lambda__Duration[count.index].Threshold
  alarm_description   = "Tracks execution duration of lambda functions."
  metric_name         = "Duration"
  namespace           = "AWS/Lambda"
  period              = 300
  statistic           = "Maximum"
  dimensions = {
    FunctionName = var.eu-west-2__lambda__Duration[count.index].ResourceName
  }
  alarm_actions       = ["${local.euw2_sns_cloudwatch_forwarder_topic}"]
  ok_actions          = ["${local.euw2_sns_cloudwatch_forwarder_topic}"]
  treat_missing_data  = "notBreaching"
}
