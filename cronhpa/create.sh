#! /bin/bash

kubectl apply -f crds/autoscaling_v1beta1_cronhorizontalpodautoscaler.yaml
kubectl apply -f rbac/rbac_role.yaml
kubectl apply -f rbac/rbac_role_binding.yaml
kubectl apply -f deploy/deploy.yaml
