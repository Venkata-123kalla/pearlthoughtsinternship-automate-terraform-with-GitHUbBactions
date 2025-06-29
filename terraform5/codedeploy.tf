# --- CodeDeploy App & Deployment Group ---
resource "aws_codedeploy_app" "strapi_app" {
  name              = "StrapiCodeDeployApp"
  compute_platform  = "ECS"
}

resource "aws_codedeploy_deployment_group" "strapi_deployment_group" {
  app_name               = aws_codedeploy_app.strapi_app.name
  deployment_group_name  = "StrapiBlueGreenDeployment"
  service_role_arn       = aws_iam_role.codedeploy_role.arn
  deployment_config_name = "CodeDeployDefault.ECSAllAtOnce"

  deployment_style {
    deployment_type   = "BLUE_GREEN"
    deployment_option = "WITH_TRAFFIC_CONTROL"
  }

  ecs_service {
    cluster_name = aws_ecs_cluster.strapi_cluster.name
    service_name = aws_ecs_service.strapi_service.name
  }

  blue_green_deployment_config {
    terminate_blue_instances_on_deployment_success {
      action                         = "TERMINATE"
      termination_wait_time_in_minutes = 5
    }

    deployment_ready_option {
      action_on_timeout = "CONTINUE_DEPLOYMENT"
    }
  }

  load_balancer_info {
    target_group_pair_info {
      target_group {
        name = aws_lb_target_group.blue.name
      }
      target_group {
        name = aws_lb_target_group.green.name
      }

      prod_traffic_route {
        listener_arns = [aws_lb_listener.listener.arn]
      }
    }
  }

  auto_rollback_configuration {
    enabled = true
    events  = ["DEPLOYMENT_FAILURE"]
  }
}


