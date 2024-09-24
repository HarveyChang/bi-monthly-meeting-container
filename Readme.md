




[L00_Prerequisitie](./Labs/L00_Prerequisitie.md)
[L01_Run_your_first_container](./Labs/L01_Run_your_first_container.md)
[L02_Build_your_first_docker_image](./Labs/L02_Build_your_first_docker_image.md)
[L03_Docker_Compose](./Labs/L03_Docker_Compose.md)

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