## get repo
helm repo add flex-gateway https://flex-packages.anypoint.mulesoft.com/helm
helm repo update

## install/update CRDs
helm template --include-crds --set registration.content=nope  -s '*.crd.yaml' flex-gateway/flex-gateway | kubectl apply -f -

# deploy
helm upgrade -n "flex-gateway" "ingress" flex-gateway/flex-gateway \
  -i --wait --create-namespace \
  --set-file registration.content=flex-reg/registration.yaml
  --set gateway.mode=connected \
  --set podSecurityContext.runAsUser=1000660010 \
  --set podSecurityContext.runAsNonRoot=true \
  --debug

# upgrade
helm get values -n "<namespace>" "<release-name>" -o yaml > current-values.yaml
helm upgrade  -n "<namespace>" "<release-name>" flex-gateway/flex-gateway --values current-values.yaml
rm current-values.yaml

helm -n flex-gateway upgrade -i --create-namespace --wait ingress flex-gateway/flex-gateway \
  --set-file registration.content=flex-reg/registration.yaml \
  --set gateway.mode=connected \
  --set podSecurityContext.runAsUser=1000660010 \
  --set podSecurityContext.runAsNonRoot=true \
  --debug
** error: Service does not have LB ingress IP address: flex-gateway/ingress
Error creating: pods "ingress-7d866bdcd4-" is forbidden: unable to validate against any security context constraint: [provider "anyuid": Forbidden: not usable by user or serviceaccount, provider restricted-v2: .containers[0].runAsUser: Invalid value: 1000660010: must be in the ranges: [1000650000, 1000659999], provider "restricted": Forbidden: not usable by user or serviceaccount, provider "nonroot-v2": Forbidden: not usable by user or serviceaccount, provider "nonroot": Forbidden: not usable by user or serviceaccount, provider "hostmount-anyuid": Forbidden: not usable by user or serviceaccount, provider "machine-api-termination-handler": Forbidden: not usable by user or serviceaccount, provider "hostnetwork-v2": Forbidden: not usable by user or serviceaccount, provider "hostnetwork": Forbidden: not usable by user or serviceaccount, provider "hostaccess": Forbidden: not usable by user or serviceaccount, provider "hostpath-provisioner": Forbidden: not usable by user or serviceaccount, provider "privileged": Forbidden: not usable by user or serviceaccount]

# pull helm chart
helm pull flex-gateway/flex-gateway --version <chart-version>
tar -xvzf flex-gateway-1.8.0.tgz -C ./