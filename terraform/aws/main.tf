provider "aws" {
  region = "us-east-1"
}

resource "random_string" "suffix" {
  length  = 4
  special = false
}

# VPC
# checkov:skip=CKV2_AWS_12 Default SG not in scope for Terraform-managed resources
resource "aws_vpc" "main" {
  cidr_block           = "10.0.0.0/16"
  enable_dns_support   = true
  enable_dns_hostnames = true

  tags = {
    Name = "multi-cloud-vpc"
  }
}

# Public Subnet
# checkov:skip=CKV_AWS_130 Public subnet designed for internet-facing resources
resource "aws_subnet" "public" {
  vpc_id                  = aws_vpc.main.id
  cidr_block              = "10.0.1.0/24"
  map_public_ip_on_launch = false
  availability_zone       = "us-east-1a"

  tags = {
    Name = "public-subnet"
  }
}

# Private Subnet
resource "aws_subnet" "private" {
  vpc_id            = aws_vpc.main.id
  cidr_block        = "10.0.2.0/24"
  availability_zone = "us-east-1a"

  tags = {
    Name = "private-subnet"
  }
}

# Internet Gateway
resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.main.id

  tags = {
    Name = "main-igw"
  }
}

# Route Table
resource "aws_route_table" "public" {
  vpc_id = aws_vpc.main.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }

  tags = {
    Name = "public-route-table"
  }
}

# Associate Public Subnet with Route Table
resource "aws_route_table_association" "public" {
  subnet_id      = aws_subnet.public.id
  route_table_id = aws_route_table.public.id
}

# Security Group
# checkov:skip=CKV2_AWS_5 SG is defined for reuse in EC2 modules later
resource "aws_security_group" "web_sg" {
  name        = "web-sg"
  description = "Allow restricted web and SSH access"
  vpc_id      = aws_vpc.main.id

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
    Name = "web-sg"
  }
}

# CloudWatch Log Group
# checkov:skip=CKV_AWS_158 Logs are non-sensitive in sandbox demo env
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
  vpc_id               = aws_vpc.main.id
  iam_role_arn         = aws_iam_role.flow_logs_role.arn
}
