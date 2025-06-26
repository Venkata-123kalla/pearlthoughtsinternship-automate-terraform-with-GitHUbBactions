output "alb_dns_name" {
  description = "Public DNS of ALB"
  value       = aws_lb.alb.dns_name
}

output "ecs_cluster_name" {
  value = aws_ecs_cluster.strapi_cluster.name
}

output "ecs_service_name" {
  value = aws_ecs_service.strapi_service.name
}

output "task_definition_arn" {
  value = aws_ecs_task_definition.strapi_task.arn
}

output "alb_listener_arn" {
  value = aws_lb_listener.listener.arn
}

output "blue_target_group_arn" {
  value = aws_lb_target_group.blue.arn
}

output "green_target_group_arn" {
  value = aws_lb_target_group.green.arn
}


