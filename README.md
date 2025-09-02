# AWS + Terraform + GitHub Actions: ECR → ECS Fargate

This repo contains:
- A simple Node.js "Hello World" app (Dockerized)
- Terraform IaC using modules to provision:
  - VPC with two public subnets
  - Application Load Balancer (HTTP :80)
  - ECS Fargate cluster, task definition, and service
  - ECR repository
- GitHub Actions:
  - CI: Build + push Docker image to ECR
  - CD: Register new task definition revision and deploy to ECS service

## Prerequisites

- AWS account with permissions to create VPC, IAM, ECR, ECS, ALB, CloudWatch Logs.
- Terraform >= 1.6
- GitHub repository with OIDC to AWS (recommended) or static AWS keys.
- Domain not required; service will be reachable via the ALB DNS name.

## Quick start

1) Install the CLI :
   - On macOS/Linux:
     - `install terraform cli and aws cli`

2) Initialize and apply Terraform (from `infra/`):
   - `cd infra`
   - `terraform init`
   - `terraform apply -auto-approve`

   Outputs you’ll get:
   - `ecr_repository_url`
   - `ecs_cluster_name`
   - `ecs_service_name`
   - `task_definition_family`
   - `alb_dns_name` (open this in your browser)

3) Configure GitHub Actions

   Recommended: GitHub OIDC with a deploy role in AWS.
   - Create an IAM role in AWS that trusts your GitHub org/repo via OIDC and allows ECR/ECS actions.
   - Add the role ARN as a GitHub secret:
     - `AWS_OIDC_ROLE_ARN` (used by both workflows)

   Also add:
   - `ECS_TASK_EXECUTION_ROLE_ARN` (output or lookup in AWS: hello-fargate-task-exec)
   - Optionally set repository variables under Settings → Variables:
     - `PROJECT_NAME = hello-fargate`
     - `ECR_REPOSITORY = hello-fargate`
     - `AWS_REGION = us-east-1`
     - `CLUSTER_NAME = hello-fargate-cluster`
     - `SERVICE_NAME = hello-fargate-svc`

   If you prefer static credentials instead of OIDC (not recommended), replace the `configure-aws-credentials` steps with access keys:
   - Add repo secrets: `AWS_ACCESS_KEY_ID`, `AWS_SECRET_ACCESS_KEY`, and set `AWS_REGION`.

4) First image and deploy
   - Push commits to `main`. CI will build and push: `<account>.dkr.ecr.<region>.amazonaws.com/hello-fargate:<short_sha>`
   - CD will register a new task definition revision and update the service.
   - Visit the `alb_dns_name` output (HTTP port 80). You should see a JSON "Hello World" response.

## How it works

- Terraform builds infra once, including an initial task definition image tag `:initial`.
- CI builds and pushes your app images to ECR tagged with the git SHA and `latest`.
- CD renders `taskdef.json` with the latest image and registers a new revision, then forces the ECS service to deploy that revision.
- The ECS service `lifecycle.ignore_changes = [task_definition]` allows CD-driven updates without Terraform drift issues.

## Common tweaks
