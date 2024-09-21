


```bash
minikube addons enable ingress
kubectl apply -f d.yaml
minikube tunnel --cleanup
kubectl delete -f d.yaml
```