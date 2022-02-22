# locals {
#   repository_url = "ghcr.io/jimmysawczuk/sun-api"
# }

# We need a cluster in which to put our service.
resource "aws_ecs_cluster" "app" {
  name = "app"
}

# # An ECR repository is a private alternative to Docker Hub.
# resource "aws_ecr_repository" "sun_api" {
#   name = "sun-api"
# }

# Log groups hold logs from our app.
resource "aws_cloudwatch_log_group" "sun_api" {
  name = "/ecs/sun-api"
}

# The main service.
resource "aws_ecs_service" "sun_api" {
  name            = "sun-api"
  task_definition = aws_ecs_task_definition.sun_api.arn
  cluster         = aws_ecs_cluster.app.id
  launch_type     = "FARGATE"

  desired_count = 1

  load_balancer {
    target_group_arn = aws_lb_target_group.sun_api.arn
    container_name   = "sun-api"
    container_port   = "3000"
  }

  network_configuration {
    assign_public_ip = false

    security_groups = [
      aws_security_group.egress_all.id,
      aws_security_group.ingress_api.id,
    ]

    subnets = [
      aws_subnet.private_d.id,
      aws_subnet.private_e.id,
    ]
  }
}

# The task definition for our app.
resource "aws_ecs_task_definition" "sun_api" {
  family = "sun-api"
  container_definitions =  jsonencode(
  [
    {
      name= "sun-api"
      image= "ghcr.io/jimmysawczuk/sun-api:latest"
      portMappings= [
        {
          "containerPort": 3000
        }
      ]
      logConfiguration= {
        logDriver= "awslogs"
        options= {
          "awslogs-region"= "us-east-1"
          "awslogs-group"= "/ecs/sun-api"
          "awslogs-stream-prefix"= "ecs"
        }
      }
    }
  ])
  execution_role_arn = aws_iam_role.sun_api_task_execution_role.arn
  # These are the minimum values for Fargate containers.
  cpu                      = 256
  memory                   = 512
  requires_compatibilities = ["FARGATE"]
  # This is required for Fargate containers (more on this later).
  network_mode = "awsvpc"
}




output "alb_url" {
  value = "http://${aws_alb.sun_api.dns_name}"
}
