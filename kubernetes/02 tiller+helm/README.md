Install Tiller (Helm server)
https://docs.bitnami.com/kubernetes/how-to/configure-rbac-in-your-kubernetes-cluster/#use-case-2-enable-helm-in-your-cluster

Create The Tiller Service Account:
```
kubectl apply -f tiller-service-account.yaml
```

Update the existing tiller-deploy deployment with the Service Account created above
```
helm init --service-account tiller --upgrade
```