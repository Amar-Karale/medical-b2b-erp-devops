# Kubernetes secrets

`app-secrets.yaml` is intentionally not stored in Git.

```bash
kubectl -n med-erp create secret generic app-secrets \\
  --from-literal=MONGODB_URI_USER="$MONGODB_URI_USER" \\
  --from-literal=MONGODB_URI_PRODUCT="$MONGODB_URI_PRODUCT" \\
  --from-literal=MONGODB_URI_ORDER="$MONGODB_URI_ORDER" \\
  --from-literal=JWT_SECRET="$JWT_SECRET" \\
  --dry-run=client -o yaml | kubectl apply -f -
```
