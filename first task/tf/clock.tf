# The ECR repository where the container is stored
data "aws_ecr_repository" "clock_mirror2real" {
  name = var.clock_container_repository
}

# ECS cluster where the service runs
resource "aws_ecs_cluster" "clock" {
  name = "clock-cluster"
}

# The definition of the task which will be run on ECS
resource "aws_ecs_task_definition" "clock" {
  family                   = "clock-task"
  container_definitions    = <<EOF
  [
    {
      "name": "clock-task",
      "image": "${data.aws_ecr_repository.clock_mirror2real.repository_url}",
      "essential": true,
      "portMappings": [
        {
          "containerPort": 80,
          "hostPort": 80
        }
      ],
      "memory": 512,
      "cpu": 256
    }
  ]
  EOF
  requires_compatibilities = ["FARGATE"]
  network_mode             = "awsvpc"
  memory                   = 512
  cpu                      = 256
  execution_role_arn       = aws_iam_role.ecs_role.arn
}

# Create role for the service
resource "aws_iam_role" "ecs_role" {
  name               = "ecsClockRole"
  assume_role_policy = data.aws_iam_policy_document.ecs_policy.json
}

# Generates an IAM policy document in JSON format
# ECS will be able to pick up the ecsClockRole
data "aws_iam_policy_document" "ecs_policy" {
  statement {
    actions = ["sts:AssumeRole"]

    principals {
      type        = "Service"
      identifiers = ["ecs-tasks.amazonaws.com"]
    }
  }
}

# Attach a Managed IAM Policy to an IAM role
resource "aws_iam_role_policy_attachment" "ecs_policy_attachment" {
  role       = aws_iam_role.ecs_role.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonECSTaskExecutionRolePolicy"
}

# Create the service itself
resource "aws_ecs_service" "clock" {
  name            = "clock-mirror2real"
  cluster         = aws_ecs_cluster.clock.id
  task_definition = aws_ecs_task_definition.clock.arn
  launch_type     = "FARGATE"
  desired_count   = 1

  network_configuration {
    subnets          = [aws_default_subnet.default_subnet_a.id, aws_default_subnet.default_subnet_b.id, aws_default_subnet.default_subnet_c.id]
    assign_public_ip = true
    security_groups  = [aws_security_group.clock.id]
  }

  load_balancer {
    target_group_arn = aws_lb_target_group.clock.arn
    container_name   = aws_ecs_task_definition.clock.family
    container_port   = 80
  }
}

# define who can communicate with the clock service
resource "aws_security_group" "clock" {
  ingress {
    from_port = 0
    to_port   = 0
    protocol  = "-1"
    security_groups = [aws_security_group.clock_alb.id]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1" 
    cidr_blocks = ["0.0.0.0/0"]
  }
}

# define where is the service listening
resource "aws_lb_target_group" "clock" {
  name        = "clock-target-group"
  port        = 80
  protocol    = "HTTP"
  target_type = "ip"
  vpc_id      = aws_default_vpc.default_vpc.id
}

# listen to the service
resource "aws_lb_listener" "clock" {
  load_balancer_arn = aws_alb.clock.arn
  port              = "80"
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.clock.arn
  }
}

# register some user-friendly DNS
resource "namecheap_record" "clock" {
  type = "CNAME"
  name = "clock"
  domain = "mbraptor.tech"
  address = aws_alb.clock.dns_name
  ttl = 3600
}