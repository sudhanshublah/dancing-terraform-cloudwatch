locals {
  all_ec2 = zipmap(data.aws_instances.my_instances.ids, data.aws_instances.my_instances.private_ips) 
}

data "aws_instances" "my_instances" {
  filter {
    name = "virtualization-type"
    values = ["hvm"]
  }
  instance_state_names = ["running"]
}


# Creating the AWS CLoudwatch Alarm that will autoscale the AWS EC2 instance based on CPU utilization.
resource "aws_cloudwatch_metric_alarm" "EC2_CPU_Usage_70_Alarm" {
# defining the name of AWS cloudwatch alarm
  for_each = local.all_ec2
  alarm_name          = "EC2_CPU_Usage_70_Alarm/${each.key}/t"
  comparison_operator = "GreaterThanOrEqualToThreshold"
  evaluation_periods = "2"
# Defining the metric_name according to which scaling will happen (based on CPU) 
  metric_name = "CPUUtilization"
# The namespace for the alarm's associated metric
  namespace = "AWS/EC2"
# After AWS Cloudwatch Alarm is triggered, it will wait for 60 seconds and then autoscales
  period = "300"
  statistic = "Average"
# CPU Utilization threshold is set to 10 percent
  threshold = "70"
  alarm_description     = "This metric monitors ec2 cpu utilization exceeding 70%"
  dimensions = {
    InstanceId = each.key
  }

  depends_on = [
    data.aws_instances.my_instances
  ]

}

# Creating the AWS CLoudwatch Alarm that will autoscale the AWS EC2 instance based on CPU utilization.
resource "aws_cloudwatch_metric_alarm" "EC2_CPU_Usage_60_Alarm" {
# defining the name of AWS cloudwatch alarm
  for_each = local.all_ec2
  alarm_name          = "EC2_CPU_Usage_60_Alarm/${each.key}/t"
  comparison_operator = "GreaterThanOrEqualToThreshold"
  evaluation_periods = "2"
# Defining the metric_name according to which scaling will happen (based on CPU) 
  metric_name = "CPUUtilization"
# The namespace for the alarm's associated metric
  namespace = "AWS/EC2"
# After AWS Cloudwatch Alarm is triggered, it will wait for 60 seconds and then autoscales
  period = "300"
  statistic = "Average"
# CPU Utilization threshold is set to 10 percent
  threshold = "60"
  alarm_description     = "This metric monitors ec2 cpu utilization exceeding 60%"
  dimensions = {
    InstanceId = each.key
  }

  depends_on = [
    data.aws_instances.my_instances
  ]

}

# Creating the AWS CLoudwatch Alarm that will autoscale the AWS EC2 instance based on CPU utilization.
resource "aws_cloudwatch_metric_alarm" "EC2_CPU_Usage_80_Alarm" {
# defining the name of AWS cloudwatch alarm
  for_each = local.all_ec2
  alarm_name          = "EC2_CPU_Usage_80_Alarm/${each.key}/t"
  comparison_operator = "GreaterThanOrEqualToThreshold"
  evaluation_periods = "2"
# Defining the metric_name according to which scaling will happen (based on CPU) 
  metric_name = "CPUUtilization"
# The namespace for the alarm's associated metric
  namespace = "AWS/EC2"
# After AWS Cloudwatch Alarm is triggered, it will wait for 60 seconds and then autoscales
  period = "300"
  statistic = "Average"
# CPU Utilization threshold is set to 10 percent
  threshold = "80"
  alarm_actions   = [aws_sns_topic.EC2_topic.arn]
  actions_enabled = true
  alarm_description     = "This metric monitors ec2 cpu utilization exceeding 80%"
  dimensions = {
    InstanceId = each.key
  }

  depends_on = [
    data.aws_instances.my_instances
  ]

}


resource "aws_cloudwatch_log_group" "ebs_log_group" {
  name = "ebs_log_group"
  retention_in_days = 30
}


resource "aws_cloudwatch_log_stream" "ebs_log_stream" {
  name           = "ebs_log_stream"
  log_group_name = aws_cloudwatch_log_group.ebs_log_group.name
}

resource "aws_sns_topic" "EC2_topic" {
  name = "EC2_topic"
}

resource "aws_sns_topic_subscription" "EC2_Subscription" {
  topic_arn = aws_sns_topic.EC2_topic.arn
  protocol  = "email"
  endpoint  = "zedcree@gmail.com"

  depends_on = [
    aws_sns_topic.EC2_topic
  ]
}


# resource "aws_cloudwatch_metric_alarm" "ec2-high-cpu-warning" {

#   for_each            = data.aws_instances.my_instances
  
#   alarm_name          = "ec2-high-cpu-warning-for-${each.key}"
#   comparison_operator = "GreaterThanThreshold"
#   evaluation_periods  = "1"
#   metric_name         = "CPUUtilization"
#   namespace           = "AWS/EC2"
  
#   dimensions = {
#     instanceid   = each.value.id
#     instancename = each.key
#   }

#   period                    = "60"
#   statistic                 = "Average"
#   threshold                 = "11"
#   alarm_description         = "This warning is for high cpu utilization for ${each.key}"
#   actions_enabled           = true
#   alarm_actions             = [aws_sns_topic.EC2_topic.arn]
#   insufficient_data_actions = []
#   treat_missing_data        = "notBreaching"

#   depends_on = [
#     aws_sns_topic.EC2_topic
#   ]
# }

# resource "aws_sns_topic" "EC2_topic" {
#   name = "EC2_topic"
# }

# resource "aws_sns_topic_subscription" "EC2_Subscription" {
#   topic_arn = aws_sns_topic.EC2_topic.arn
#   protocol  = "email"
#   endpoint  = "automateinfra@gmail.com"

#   depends_on = [
#     aws_sns_topic.EC2_topic
#   ]
# }
