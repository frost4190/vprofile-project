#!/bin/bash

# Deploy vprofile application to Kubernetes

echo "Creating namespace..."
kubectl apply -f namespace.yaml

echo "Creating secrets..."
kubectl apply -f secret.yaml

echo "Creating database ConfigMap..."
kubectl apply -f db-configmap.yaml

echo "Creating PVC..."
kubectl apply -f dbpvc.yaml

echo "Deploying database..."
kubectl apply -f dbdeploy.yaml
kubectl apply -f dbservice.yaml

echo "Deploying Memcached..."
kubectl apply -f mcdep.yaml
kubectl apply -f mcservice.yaml

echo "Deploying RabbitMQ..."
kubectl apply -f rmqdeploy.yaml
kubectl apply -f rmqservice.yaml

echo "Waiting for services to be ready..."
sleep 30

echo "Deploying application..."
kubectl apply -f appdeploy.yaml
kubectl apply -f appservice.yaml

echo "Creating Ingress..."
kubectl apply -f appingress.yaml

echo "Deployment complete!"
echo "Check status with: kubectl get all -n vprofile"