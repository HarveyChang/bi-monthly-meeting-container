


```bash

sudo usermod -aG docker $USER && newgrp docker

cd ~/bi-monthly-meeting-container/minikube

minikube start --driver=docker
minikube addons enable ingress
kubectl apply -f deployment.yaml

curl http://$(minikube ip)


minikube tunnel --cleanup
kubectl delete -f deployment.yaml
```