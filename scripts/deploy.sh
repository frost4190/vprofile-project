#!/bin/bash
set -e

ENVIRONMENT=${1:-dev}
NAMESPACE="vprofile-${ENVIRONMENT}"

echo "Deploying to ${ENVIRONMENT} environment..."

# Add Helm repositories
helm repo add bitnami https://charts.bitnami.com/bitnami
helm repo add prometheus-community https://prometheus-community.github.io/helm-charts
helm repo update

# Create namespace
kubectl create namespace ${NAMESPACE} --dry-run=client -o yaml | kubectl apply -f - --validate=false

# Deploy monitoring (production only)
if [ "$ENVIRONMENT" = "prod" ]; then
    echo "Installing monitoring stack..."
    helm upgrade --install prometheus prometheus-community/kube-prometheus-stack \
        --namespace monitoring \
        --create-namespace \
        -f monitoring/prometheus-values.yaml
fi

# Deploy application
echo "Deploying vprofile application..."
helm upgrade --install vprofile-${ENVIRONMENT} ./helm/vprofile \
    --namespace ${NAMESPACE} \
    --set image.tag=latest \
    --set ingress.hosts[0].host=vprofile-${ENVIRONMENT}.local \
    --wait --timeout=10m

echo "Deployment completed successfully!"
echo "Access the application at: http://vprofile-${ENVIRONMENT}.local"