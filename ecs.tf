resource "aws_ecs_cluster" "app_cluster" {
  name = "my-ecs-cluster"
}

resource "aws_ecs_task_definition" "app_task" {
  family                   = "ipfs-metadata-app"
  network_mode             = "awsvpc"
  container_definitions    = jsonencode([{
    name      = "app"
    image     = var.container_image
    cpu       = var.ecs_task_cpu
    memory    = var.ecs_task_memory
    essential = true
    portMappings = [{
      containerPort = var.container_port
      hostPort      = var.container_port
    }]
    environment = [
      {
        name  = "POSTGRES_USER"
        value = var.db_username
      },
      {
        name  = "POSTGRES_PASSWORD"
        value = var.db_password
      },
      {
        name  = "POSTGRES_HOST"
        value = var.rds_endpoint
      }
    ]
  }])
  requires_compatibilities = ["FARGATE"]
  execution_role_arn       = aws_iam_role.ecs_task_execution.arn
  task_role_arn            = aws_iam_role.ecs_task_execution.arn
  cpu                      = var.ecs_task_cpu
  memory                   = var.ecs_task_memory
}

resource "aws_ecs_service" "app_service" {
  name            = "ipfs-metadata-service"
  cluster         = aws_ecs_cluster.app_cluster.id
  task_definition = aws_ecs_task_definition.app_task.arn
  desired_count   = 1
  launch_type     = "FARGATE"

  network_configuration {
    subnets         = var.ecs_subnet_ids
    security_groups = [aws_security_group.ecs_service.id]
  }

  load_balancer {
    target_group_arn = var.target_group_arn
    container_name   = "app"
    container_port   = var.container_port
  }
}