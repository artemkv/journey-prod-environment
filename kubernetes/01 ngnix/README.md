Install Ngnix as DaemonSet:
```
helm install stable/nginx-ingress --name nginx-ingress --set rbac.create=true --set controller.kind=DaemonSet --namespace kube-system
```

After that, use the following command to find out the ngnix external IP:
```
kubectl get service nginx-ingress-controller -n kube-system
```

Configure DNS record pointing to that IP