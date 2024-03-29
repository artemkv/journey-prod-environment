Install the CustomResourceDefinition resources separately

```
kubectl apply --validate=false -f https://raw.githubusercontent.com/jetstack/cert-manager/release-0.11/deploy/manifests/00-crds.yaml
```

Create the namespace for cert-manager

```
kubectl create namespace cert-manager
```

Add the Jetstack Helm repository

```
helm repo add jetstack https://charts.jetstack.io
helm repo update
```

Install the cert-manager Helm chart

```
helm install --name cert-manager --namespace cert-manager --version v0.11.0 jetstack/cert-manager
```

Create cluster cert issuer

```
kubectl apply -f cluster-issuer.yaml
```

Verify cluster issuer (check "Ready" condition):

```
kubectl describe clusterissuer letsencrypt-prod
```