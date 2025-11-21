# VProfile Production Deployment

## Architecture Overview

This production-ready setup includes:

- **Containerization**: Multi-stage Docker builds with security hardening
- **Orchestration**: Kubernetes with Helm charts
- **CI/CD**: GitHub Actions with automated testing and deployment
- **Infrastructure**: Terraform for EKS cluster provisioning
- **Monitoring**: Prometheus, Grafana, and Alertmanager
- **Security**: Trivy scanning, non-root containers, TLS termination

## Quick Start

### 1. Infrastructure Setup
```bash
cd terraform
terraform init
terraform plan
terraform apply
```

### 2. Configure kubectl
```bash
aws eks update-kubeconfig --name vprofile-cluster --region us-east-1
```

### 3. Deploy Application
```bash
# Development
./scripts/deploy.sh dev

# Production
./scripts/deploy.sh prod
```

### 4. Local Development with Skaffold
```bash
skaffold dev --profile=dev
```

## CI/CD Pipeline

The GitHub Actions pipeline includes:

1. **Testing**: Unit tests with Maven
2. **Security**: Trivy vulnerability scanning
3. **Build**: Multi-stage Docker build with caching
4. **Deploy**: Automated deployment to staging and production

### Required Secrets

Set these in GitHub repository secrets:
- `DOCKER_USERNAME`
- `DOCKER_PASSWORD`
- `AWS_ACCESS_KEY_ID`
- `AWS_SECRET_ACCESS_KEY`

## Monitoring

Access monitoring dashboards:
- Grafana: `http://grafana.yourdomain.com`
- Prometheus: `http://prometheus.yourdomain.com`

## Production Features

- **Auto-scaling**: HPA based on CPU/Memory
- **High Availability**: Multi-replica deployment
- **Health Checks**: Liveness and readiness probes
- **Resource Management**: CPU/Memory limits and requests
- **Security**: TLS termination, non-root containers
- **Monitoring**: Comprehensive metrics and alerting

## Environment Management

- **Development**: Single replica, minimal resources
- **Staging**: Production-like with reduced resources
- **Production**: Multi-replica, full monitoring, auto-scaling

## Helm Chart Features

- Bitnami dependencies for MySQL, Memcached, RabbitMQ
- Configurable resource limits
- TLS/SSL support with cert-manager
- Horizontal Pod Autoscaler
- Service monitoring with Prometheus