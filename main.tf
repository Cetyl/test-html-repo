provider "aws" {
  region = "us-east-1"
}

# Define the VPC
resource "aws_vpc" "example" {
  cidr_block = "10.0.0.0/16"
}

# Define an internet gateway
resource "aws_internet_gateway" "example" {
  vpc_id = aws_vpc.example.id
}

# Define a route table
resource "aws_route_table" "example" {
  vpc_id = aws_vpc.example.id
}

# Define a route to the internet gateway
resource "aws_route" "internet_access" {
  route_table_id         = aws_route_table.example.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.example.id
}

# Associate the route table with the public subnets
resource "aws_route_table_association" "public_subnet_1" {
  subnet_id      = aws_subnet.public_subnet_1.id
  route_table_id = aws_route_table.example.id
}

resource "aws_route_table_association" "public_subnet_2" {
  subnet_id      = aws_subnet.public_subnet_2.id
  route_table_id = aws_route_table.example.id
}

# Define public subnets in different Availability Zones
resource "aws_subnet" "public_subnet_1" {
  vpc_id                  = aws_vpc.example.id
  cidr_block              = "10.0.18.0/24"
  availability_zone       = "us-east-1a"
  map_public_ip_on_launch = true
}

resource "aws_subnet" "public_subnet_2" {
  vpc_id                  = aws_vpc.example.id
  cidr_block              = "10.0.12.0/24"
  availability_zone       = "us-east-1b"
  map_public_ip_on_launch = true
}

# Define the ECS cluster
resource "aws_ecs_cluster" "bangon" {
  name = "bangon"
}

# Define an ECS task definition
resource "aws_ecs_task_definition" "my_web_app" {
  family                   = "my-web-app-task"
  network_mode             = "awsvpc"
  requires_compatibilities = ["FARGATE"]
  cpu                      = "256"
  memory                   = "512"

  container_definitions = jsonencode([{
    name      = "my-web-app-container"
    image     = "730335620727.dkr.ecr.us-east-1.amazonaws.com/my-web-app:latest"
    essential = true
    portMappings = [{
      containerPort = 80
      hostPort      = 80
      protocol      = "tcp"
    }]
  }])

  execution_role_arn = aws_iam_role.ecs_execution_role.arn
  task_role_arn      = aws_iam_role.ecs_task_role.arn
}

# Define the ECS service
resource "aws_ecs_service" "my_web_app_service" {
  name            = "my-web-app-service"
  cluster         = aws_ecs_cluster.bangon.id
  task_definition = aws_ecs_task_definition.my_web_app.arn
  desired_count   = 1
  launch_type     = "FARGATE"

  network_configuration {
    subnets          = [aws_subnet.public_subnet_1.id, aws_subnet.public_subnet_2.id]
    security_groups   = [aws_security_group.example.id]
    assign_public_ip  = true
  }

  load_balancer {
    target_group_arn = aws_lb_target_group.my_web_app_tg.arn
    container_name   = "my-web-app-container"
    container_port   = 80
  }

  depends_on = [
    aws_lb_listener.my_web_app_listener
  ]
}

# Define a security group
resource "aws_security_group" "example" {
  vpc_id = aws_vpc.example.id

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

# Define the Application Load Balancer
resource "aws_lb" "my_web_app_alb" {
  name               = "my-web-app-alb"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.example.id]
  subnets            = [aws_subnet.public_subnet_1.id, aws_subnet.public_subnet_2.id]
}

# Define a listener for the Application Load Balancer
resource "aws_lb_listener" "my_web_app_listener" {
  load_balancer_arn = aws_lb.my_web_app_alb.arn
  port              = 80
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.my_web_app_tg.arn
  }
}

# Define a target group for the load balancer with target type `ip`
resource "aws_lb_target_group" "my_web_app_tg" {
  name     = "my-web-app-tg"
  port     = 80
  protocol = "HTTP"
  vpc_id   = aws_vpc.example.id

  # Set target type to `ip` for awsvpc network mode
  target_type = "ip"

  health_check {
    path                = "/"
    interval            = 30
    timeout             = 5
    healthy_threshold   = 2
    unhealthy_threshold = 2
  }
}


