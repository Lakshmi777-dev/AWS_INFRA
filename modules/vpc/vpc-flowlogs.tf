resource "aws_flow_log" "vpc_flow_log" {
#   count = var.enable_flow_logs ? 1 : 0
  for_each = toset(var.flow_log_bucket)

  log_destination      = format("arn:aws:s3:::%s",each.value)
  log_destination_type = "s3"
  traffic_type         = "ALL" # You can change this as required (e.g., ACCEPT, REJECT)
  vpc_id               = aws_vpc.main.id  # Replace with your VPC ID variable if needed

  tags = {
    Name = "flow-log-${aws_vpc.main.id}"  # Adjust this as needed
  }
}