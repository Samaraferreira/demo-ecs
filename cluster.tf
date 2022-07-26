resource "aws_ecs_cluster" "cluster" {
  name = var.cluster_name
}

resource "aws_cloudwatch_log_group" "demo-app" {
  name = "${var.cluster_name}-logs"
}
