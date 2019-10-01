Install Traefik as a Kubernetes Ingress Controller 
https://docs.traefik.io/v1.7/user-guide/kubernetes/

Authorize Traefik to use the Kubernetes API:
```
kubectl apply -f traefik-rbac.yaml
```

Deploy Traefik using a DaemonSet:
```
kubectl apply -f traefik-ds.yaml
```

Make sure the traefik service is configured as ```type: LoadBalancer```

After that, use the following command to find out the traefik external IP:
```
kubectl get service traefik-ingress-service -n kube-system
```

Configure DNS record pointing to that IP