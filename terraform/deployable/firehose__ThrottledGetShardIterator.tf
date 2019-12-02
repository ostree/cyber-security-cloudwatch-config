variable "eu-west-1__firehose__ThrottledGetSharditerator" {
  description = "List of metrics derived from aws cloudwatch list-metrics"
  type        = list
  default     = []
}

variable "eu-west-2__firehose__ThrottledGetSharditerator" {
  description = "List of metrics derived from aws cloudwatch list-metrics"
  type        = list
  default     = []
}

resource "aws_cloudwatch_metric_alarm" "euw1_cloudwatch_firehose_throttled_get_shard_iterator" {
  # iterate over count to setup multiple alarms
  count               = length(var.eu-west-1__firehose__ThrottledGetSharditerator)
  provider            = aws.eu-west-1
  alarm_name          = "${var.eu-west-1__firehose__ThrottledGetSharditerator[count.index].ResourceName}_alarm"
  comparison_operator = "GreaterThanOrEqualToThreshold"
  evaluation_periods  = 2
  threshold           = var.eu-west-1__firehose__ThrottledGetSharditerator[count.index].Threshold
  alarm_description   = "Tracks the read position across all shards and consumers in the stream. If an iterator's age passes 50% of the retention period (by default, 24 hours, configurable up to 7 days), there is risk for data loss due to record expiration."
  metric_name         = "ThrottledGetSharditerator"
  namespace           = "AWS/Firehose"
  period              = 300
  statistic           = "Maximum"
  dimensions = {
    QueueName = var.eu-west-1__firehose_ThrottledGetSharditerator[count.index].ResourceName
  }
  alarm_actions       = ["${local.euw1_sns_health_topic}"]
  ok_actions          = ["${local.euw1_sns_health_topic}"]
}

resource "aws_cloudwatch_metric_alarm" "euw2_cloudwatch_firehose_get_shard_iterator" {
  # iterate over count to setup multiple alarms
  count               = length(var.eu-west-2__firehose__ThrottledGetSharditerator)
  provider            = aws.eu-west-2
  alarm_name          = "${var.eu-west-2__firehose__ThrottledGetSharditerator[count.index].ResourceName}_alarm"
  comparison_operator = "GreaterThanOrEqualToThreshold"
  evaluation_periods  = 2
  threshold           = var.eu-west-2__firehose__ThrottledGetSharditerator[count.index].Threshold
  alarm_description   = "Tracks the read position across all shards and consumers in the stream. If an iterator's age passes 50% of the retention period (by default, 24 hours, configurable up to 7 days), there is risk for data loss due to record expiration."
  metric_name         = "ThrottledGetSharditerator"
  namespace           = "AWS/Firehose"
  period              = 300
  statistic           = "Maximum"
  dimensions = {
    QueueName = var.eu-west-2__firehose_ThrottledGetSharditerator[count.index].ResourceName
  }
  alarm_actions       = ["${local.euw2_sns_health_topic}"]
  ok_actions          = ["${local.euw2_sns_health_topic}"]
}