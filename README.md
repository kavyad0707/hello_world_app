# AWS + Terraform + GitHub Actions: ECR → ECS Fargate

This repo contains:
- A simple Node.js "Hello World" app (Dockerized)
- Terraform IaC using modules to provision:
  - VPC with one public subnet
  - Application Load Balancer (HTTP :80)
  - ECS Fargate cluster, task definition, and service
  - ECR repository
- GitHub Actions:
  - CI-CD: Build + push Docker image to ECR + Register new task definition revision and deploy to ECS service

## Prerequisites

- AWS account with permissions to create VPC, ECR, ECS, ALB.
- Terraform >= 1.12.2

## Quick start

1) Install the CLI :
   - On macOS/Linux:
     - `install terraform cli and aws cli`

2) Initialize and apply Terraform (from `infra/`):
   - `cd infra`
   - `terraform init`
   - `terraform plan`
   - `terraform apply -auto-approve`

3) Configure GitHub Actions

   Add Settings → Variables:
     - `PROJECT_NAME = hello-fargate`
     - `ECR_REPOSITORY = hello-fargate`
     - `AWS_REGION = us-east-1`
     - `CLUSTER_NAME = hello-fargate-cluster`
     - `SERVICE_NAME = hello-fargate-svc`

   Add `configure-aws-credentials` steps with access keys:
   - Add repo secrets: `AWS_ACCESS_KEY_ID`, `AWS_SECRET_ACCESS_KEY`, and set `AWS_REGION`.

4) First image and deploy
   - Push commits to `main`. CI will build and push: `<account>.dkr.ecr.<region>.amazonaws.com/hello-fargate:<short_sha>`
   - CD will register a new task definition revision and update the service.
   - Visit the `alb_dns_name` output (HTTP port 80). You should see a JSON "Hello World" response.

## How it works

- Terraform builds infra once.
- CI-CD builds and pushes your app images to ECR tagged with `latest` (CD renders `taskdef.json` with the latest image and registers a new revision, then forces the ECS service to deploy that revision).
