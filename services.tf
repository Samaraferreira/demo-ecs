resource "aws_ecs_service" "web-api" {
  name            = var.cluster_name
  task_definition = aws_ecs_task_definition.web-api.arn
  cluster         = aws_ecs_cluster.cluster.id
  launch_type     = "FARGATE"
  desired_count   = var.desired_tasks

  network_configuration {
    security_groups  = [aws_security_group.app_sg.id, aws_security_group.alb_sg.id]
    subnets          = [aws_subnet.public_subnet_us_east_1a.id, aws_subnet.public_subnet_us_east_1b.id]
    assign_public_ip = true
  }

  load_balancer {
    target_group_arn = aws_alb_target_group.api_target_group.arn
    container_name   = var.container_name
    container_port   = var.container_port
  }

  lifecycle {
    ignore_changes = [desired_count, task_definition]
  }

  depends_on = [aws_alb_target_group.api_target_group]
}
