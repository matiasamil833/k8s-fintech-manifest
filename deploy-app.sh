### Database
kubectl apply -f namespace-db.yaml
kubectl apply -f secrets/db-db-secret.yaml
kubectl apply -f database/pv.yaml
kubectl apply -f database/pvc.yaml
kubectl apply -f database/configmap.yaml
kubectl apply -f database/service.yaml
kubectl apply -f database/statefulset.yaml
sleep 10
### App
kubectl apply -f namespace-app.yaml
kubectl apply -f secrets/app-db-secret.yaml
### Backend
kubectl apply -f backend/configmap.yaml
kubectl apply -f backend/service.yaml
kubectl apply -f backend/deployment.yaml
kubectl apply -f backend/hpa.yaml
sleep 10
### Frontend
export EXTERNAL_IP=$(kubectl get svc backend -n fintech-app -o jsonpath='{.status.loadBalancer.ingress[0].hostname}')
envsubst < frontend/configmap.yaml > frontend/configmap.tmp.yaml
kubectl apply -f frontend/configmap.tmp.yaml
rm frontend/configmap.tmp.yaml
unset EXTERNAL_IP
kubectl apply -f frontend/service.yaml
kubectl apply -f frontend/deployment.yaml
kubectl apply -f frontend/hpa.yaml