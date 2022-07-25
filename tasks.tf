resource "aws_ecs_task_definition" "web-api" {
  family                   = "${var.cluster_name}_app"
  requires_compatibilities = ["FARGATE"]
  network_mode             = "awsvpc"
  cpu                      = var.desired_task_cpu
  memory                   = var.desired_task_memory

  execution_role_arn = aws_iam_role.ecs_execution_role.arn
  task_role_arn      = aws_iam_role.ecs_execution_role.arn

  container_definitions = jsonencode([
    {
      name      = var.container_name
      image     = "${data.aws_caller_identity.current.account_id}.dkr.ecr.us-east-1.amazonaws.com/demo-repo:latest"
      cpu       = 256
      memory    = 512
      essential = true
      portMappings = [
        {
          containerPort = 8080
          hostPort      = 8080
        }
      ]
      networkMode = "awsvpc"
      logConfiguration = {
        logDriver = "awslogs",
        options = {
          "awslogs-region"        = "${var.aws_region}",
          "awslogs-group"         = "${aws_cloudwatch_log_group.demo-app.name}",
          "awslogs-stream-prefix" = "${var.container_name}"
        }
      }
    }
  ])
}
