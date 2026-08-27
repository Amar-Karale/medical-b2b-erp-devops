# Medical B2B ERP — DevOps Portfolio Project

A cloud-native Medical B2B ERP platform implemented as a microservices application and prepared as a hands-on DevOps portfolio project.

> **Attribution:** This repository is an adapted DevOps implementation based on the publicly accessible EduBlitz Medical B2B ERP reference project. See [ATTRIBUTION.md](ATTRIBUTION.md).

## Architecture

```text
                            Internet
                               |
                        +------v------+
                        | CloudFront  |
                        | React/Vite  |
                        +------+------+
                               |
                        +------v------+
                        | AWS ALB /   |
                        | EKS Ingress |
                        +------+------+
                               |
           +-------------------+-------------------+
           |                   |                   |
     +-----v-----+       +-----v------+      +-----v-----+
     | user      |       | product    |      | order     |
     | service   |       | service    |      | service   |
     | :8081     |       | :8082      |      | :8083     |
     +-----+-----+       +-----+------+      +-----+-----+
           |                   |                   |
           +-------------------+-------------------+
                               |
                        +------v------+
                        | MongoDB     |
                        | Atlas       |
                        +-------------+

CI/CD: Jenkins -> Maven tests -> Docker -> Trivy -> ECR -> EKS
IaC: Terraform -> VPC -> EKS -> ECR -> S3/CloudFront -> Route53
```

## Technology stack

- **AWS:** EKS, VPC, ALB, ECR, S3, CloudFront, Route53, IAM
- **IaC:** Terraform modules
- **CI/CD:** Jenkins
- **Security:** Trivy image scanning, Kubernetes Secrets, IAM roles
- **Containers:** Docker
- **Orchestration:** Kubernetes / Amazon EKS
- **Backend:** Java 17, Spring Boot, Maven
- **Frontend:** React 18, Vite, TailwindCSS
- **Database:** MongoDB Atlas
- **API:** REST + Swagger/OpenAPI

## Microservices

| Service | Port | Responsibility |
|---|---:|---|
| `user-service` | 8081 | Authentication, JWT, RBAC, organizations |
| `product-service` | 8082 | Product catalog and inventory |
| `order-service` | 8083 | Orders, billing simulation and order history |

## DevOps implementation

1. Modular Terraform provisions the AWS networking and EKS foundation.
2. Docker images package the three Spring Boot services and frontend.
3. Jenkins builds and tests the services.
4. Trivy scans container images for HIGH/CRITICAL vulnerabilities.
5. Images are pushed to Amazon ECR.
6. Kubernetes manifests deploy the services to EKS with rolling updates and health probes.
7. MongoDB Atlas provides the managed database layer.
8. CloudFront/S3 can serve the frontend, while Route53 manages DNS when a real domain is supplied.

## AWS region

The primary deployment region for this portfolio setup is **US West (N. California) — `us-west-1`**.

CloudFront is global. If custom CloudFront HTTPS domains are used, the ACM certificate must be in `us-east-1`, which is an AWS CloudFront requirement.

## Security decisions

- Real secrets are excluded from Git.
- Kubernetes secrets use a safe example template only.
- JWT secrets are required through environment variables instead of being hard-coded.
- AWS access should use IAM roles where possible; long-lived access keys are not required on an EC2 instance with an attached role.
- Trivy remains enabled in the CI/CD flow.
- Terraform state is intended for protected S3 remote storage with S3-native locking.

## Prerequisites

- AWS CLI configured through an IAM role or protected credentials
- Terraform 1.15+
- Docker
- kubectl
- Helm
- Java 17+
- Node.js 20+
- Jenkins
- MongoDB Atlas account

## Terraform deployment

Terraform environments are under `terraform/env/dev` and `terraform/env/prod`.

Before `terraform init`, create the remote state bucket and provide its name through backend configuration. Do not commit Terraform state or credentials.

```bash
cd terraform/env/dev
terraform init -backend-config="bucket=<YOUR-TERRAFORM-STATE-BUCKET>"
terraform validate
terraform plan -var-file=terraform.tfvars
```

Create `terraform.tfvars` from the provided example and supply only your own infrastructure values. It is ignored by Git.

## MongoDB Atlas

The application expects `users_db`, `products_db`, and `orders_db`. Store Atlas connection strings in protected environment variables or Kubernetes Secrets.

## Jenkins

- `Jenkinsfile.infra` — Terraform plan/apply flow
- `Jenkinsfile.backend` — backend build, image build, Trivy scan and EKS deployment
- `Jenkinsfile.frontend` — frontend build and container delivery

Configure credentials in Jenkins rather than hard-coding them in pipeline files.

## Resume-ready skills

**AWS | Terraform | EKS | Kubernetes | Docker | Jenkins | CI/CD | Trivy | ECR | S3 | CloudFront | Route53 | IAM | Linux | Java | Spring Boot | React | MongoDB Atlas | Infrastructure as Code**

## Attribution

See [ATTRIBUTION.md](ATTRIBUTION.md).
