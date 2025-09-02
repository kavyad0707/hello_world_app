output "cluster_name" {
  value = aws_ecs_cluster.ecs_cluster.name
}

output "service_name" {
  value = aws_ecs_service.ecs_service.name
}

output "alb_dns_name" {
  value = aws_lb.app.dns_name
}
