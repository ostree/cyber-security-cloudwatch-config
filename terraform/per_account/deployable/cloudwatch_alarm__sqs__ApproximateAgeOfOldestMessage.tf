variable "eu-west-1__sqs__ApproximateAgeOfOldestMessage" {
  description = "List of metrics derived from aws cloudwatch list-metrics"
  type        = list
  default     = []
}

variable "eu-west-2__sqs__ApproximateAgeOfOldestMessage" {
  description = "List of metrics derived from aws cloudwatch list-metrics"
  type        = list
  default     = []
}

resource "aws_cloudwatch_metric_alarm" "euw1_cloudwatch_sqs_approx_age" {
  # iterate over count to setup multiple alarms
  count               = length(var.eu-west-1__sqs__ApproximateAgeOfOldestMessage)
  provider            = aws.eu-west-1
  alarm_name          = "${var.eu-west-1__sqs__ApproximateAgeOfOldestMessage[count.index].ResourceName}_ApproximateAgeOfOldestMessage_alarm"
  comparison_operator = "GreaterThanOrEqualToThreshold"
  evaluation_periods  = 2
  threshold           = var.eu-west-1__sqs__ApproximateAgeOfOldestMessage[count.index].Threshold
  alarm_description   = "Check that messages are being processed in a reasonable time frame."
  metric_name         = "ApproximateAgeOfOldestMessage"
  namespace           = "AWS/SQS"
  period              = 300
  statistic           = "Maximum"
  dimensions = {
    QueueName = var.eu-west-1__sqs__ApproximateAgeOfOldestMessage[count.index].ResourceName
  }
  alarm_actions       = ["${local.euw1_sns_cloudwatch_forwarder_topic}"]
  ok_actions          = ["${local.euw1_sns_cloudwatch_forwarder_topic}"]
}


resource "aws_cloudwatch_metric_alarm" "euw2_cloudwatch_sqs_approx_age" {
  # iterate over count to setup multiple alarms
  count               = length(var.eu-west-2__sqs__ApproximateAgeOfOldestMessage)
  provider            = aws.eu-west-2
  alarm_name          = "${var.eu-west-2__sqs__ApproximateAgeOfOldestMessage[count.index].ResourceName}_ApproximateAgeOfOldestMessage_alarm"
  comparison_operator = "GreaterThanOrEqualToThreshold"
  evaluation_periods  = 2
  threshold           = var.eu-west-2__sqs__ApproximateAgeOfOldestMessage[count.index].Threshold
  alarm_description   = "Check that messages are being processed in a reasonable time frame."
  metric_name         = "ApproximateAgeOfOldestMessage"
  namespace           = "AWS/SQS"
  period              = 300
  statistic           = "Maximum"
  dimensions = {
    QueueName = var.eu-west-2__sqs__ApproximateAgeOfOldestMessage[count.index].ResourceName
  }
  alarm_actions       = ["${local.euw2_sns_cloudwatch_forwarder_topic}"]
  ok_actions          = ["${local.euw2_sns_cloudwatch_forwarder_topic}"]
}

