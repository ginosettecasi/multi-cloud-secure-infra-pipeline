provider "aws" {
  region = "us-east-1"
}

# Use random integer to vary subnet range on each deploy
resource "random_integer" "cidr_offset" {
  min = 10
  max = 250
}

resource "random_string" "suffix" {
  length  = 4
  special = false
  upper   = false
}

# Public Subnet
resource "aws_subnet" "public" {
  vpc_id                  = var.vpc_id
  cidr_block              = "10.0.${random_integer.cidr_offset.result}.0/24"
  map_public_ip_on_launch = false
  availability_zone       = "us-east-1a"

  tags = {
    Name = "public-subnet-${random_string.suffix.result}"
  }
}

# Private Subnet
resource "aws_subnet" "private" {
  vpc_id            = var.vpc_id
  cidr_block        = "10.0.${random_integer.cidr_offset.result + 1}.0/24"
  availability_zone = "us-east-1a"

  tags = {
    Name = "private-subnet-${random_string.suffix.result}"
  }
}

# Route Table (skip IGW to avoid AWS quota issues)
resource "aws_route_table" "public" {
  vpc_id = var.vpc_id

  tags = {
    Name = "public-route-table-${random_string.suffix.result}"
  }
}

# Associate Public Subnet with Route Table
resource "aws_route_table_association" "public" {
  subnet_id      = aws_subnet.public.id
  route_table_id = aws_route_table.public.id
}

# Security Group
resource "aws_security_group" "web_sg" {
  name        = "web-sg-${random_string.suffix.result}"
  description = "Allow restricted web and SSH access"
  vpc_id      = var.vpc_id

  ingress {
    description = "Allow SSH from trusted IP"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["${var.trusted_ip}/32"]
  }

  ingress {
    description = "Allow HTTP from trusted IP"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["${var.trusted_ip}/32"]
  }

  egress {
    description = "Allow web traffic only"
    from_port   = 80
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["10.0.0.0/8", "172.16.0.0/12", "192.168.0.0/16"]
  }

  tags = {
    Name = "web-sg-${random_string.suffix.result}"
  }
}

# CloudWatch Log Group
resource "aws_cloudwatch_log_group" "vpc_flow_logs" {
  name              = "/aws/vpc/flow-logs-${random_string.suffix.result}"
  retention_in_days = 365

  lifecycle {
    prevent_destroy = true
  }
}

# IAM Role for Flow Logs
resource "aws_iam_role" "flow_logs_role" {
  name = "flow-logs-role-${random_string.suffix.result}"

  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [{
      Action = "sts:AssumeRole",
      Effect = "Allow",
      Principal = {
        Service = "vpc-flow-logs.amazonaws.com"
      }
    }]
  })

  lifecycle {
    prevent_destroy = true
  }
}

# IAM Policy Attachment
resource "aws_iam_role_policy_attachment" "flow_logs_policy" {
  role       = aws_iam_role.flow_logs_role.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonAPIGatewayPushToCloudWatchLogs"
}

# VPC Flow Logs
resource "aws_flow_log" "vpc_flow" {
  log_destination      = aws_cloudwatch_log_group.vpc_flow_logs.arn
  log_destination_type = "cloud-watch-logs"
  traffic_type         = "ALL"
  vpc_id               = var.vpc_id
  iam_role_arn         = aws_iam_role.flow_logs_role.arn
}
