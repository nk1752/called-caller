# Flex Gateway

Anypoint Flex Gateway is an ultrafast API gateway designed to manage and secure APIs running anywhere. Built to seamlessly integrate with DevOps and CI/CD workflows, Anypoint Flex Gateway delivers the performance required for the most demanding applications and microservices while providing enterprise security and manageability across any environment.

## Get repository

```shell
helm repo add flex-gateway https://flex-packages.anypoint.mulesoft.com/helm

helm repo update
```

## Install/Update CRDs

```shell
helm template --include-crds --set registration.content=nope  -s '*.crd.yaml' flex-gateway/flex-gateway | kubectl apply -f -
```

## Deploy

```shell
helm upgrade -n "<namespace>" "<release-name>" flex-gateway/flex-gateway \
  -i --wait --create-namespace \
  --set-file registration.content=registration.yaml
```

## Upgrade

```shell
helm get values -n "<namespace>" "<release-name>" -oyaml > current-values.yaml

helm upgrade  -n "<namespace>" "<release-name>" flex-gateway/flex-gateway --values current-values.yaml

rm current-values.yaml
```

## Values

| Key | Type | Default | Description |
|-----|------|---------|-------------|
| affinity | object | `{}` |  |
| autoscaling.behavior | object | `{}` |  |
| autoscaling.enabled | bool | `false` | Boolean that indicates if the Horizontal Pod Autoscaler (HPA) is enabled |
| autoscaling.extraMetrics | list | `[]` |  |
| autoscaling.maxReplicas | int | `11` | Maximum number of replicas that the scaler is allowed to create |
| autoscaling.minReplicas | int | `2` | Minimum number of replicas that the scaler is allowed to create |
| autoscaling.targetCPUUtilizationPercentage | int | `50` | Average CPU usage percentage of all deployed Pods |
| autoscaling.targetMemoryUtilizationPercentage | string | `null` | Average memory usage percentage of all deployed Pods |
| dnsConfig | object | `{}` | Optional customization for the Pod `dnsConfig` |
| dnsPolicy | string | `"ClusterFirst"` | Set to `ClusterFirstWithHostNet` if `hostNetwork: true`. By default, the name resolution uses the host DNS while using the host network. To make Flex Gateway resolve names in the k8s network, use `ClusterFirstWithHostNet`. |
| extraAnnotations | object | `{}` | Annotations added to the Deployment |
| extraEnvs | list | `[]` | Additional environment variables to set |
| extraLabels | object | `{}` | Labels added to the Deployment |
| extraVolumeMounts | list | `[]` | Additional `volumeMounts` |
| extraVolumes | list | `[]` | Additional volumes to the Pod |
| gateway.configuration | object | `null` | gateway.mulesoft.com/v1beta1 Configuration to be defined when installing the helm chart. Ref: https://docs.mulesoft.com/gateway/latest/flex-local-configuration-reference-guide#configuration |
| gateway.connectionIdleTimeout | int | `60` | Defines the connection idle timeout of all apis. It should be the number of seconds. |
| gateway.dataSources.kubernetes.enabled | bool | `true` | Setting to define if the gateway reads the resources from Kubernetes |
| gateway.dataSources.kubernetes.selector | string | `null` | Selector (label query) that the gateway uses to filter the resources when generating the configuration. For example, "label1=value1,label2=value2" applies to the resources that have both labels: "label1=value1" and "label2=value2". |
| gateway.drainSeconds | int | `25` | The time in seconds that Flex will drain connections when individual apis are being modified or removed. During the drain sequence, the drain manager encourages draining through terminating  connections on request completion, sending “Connection: CLOSE” on HTTP1, and sending GOAWAY on HTTP2. |
| gateway.forwardClientCertDetails | string | `"SANITIZE"` | Defines how to handle the x-forwarded-client-cert (XFCC) HTTP header. Possible values: `SANITIZE`, `FORWARD_ONLY`, `APPEND_FORWARD`, `SANITIZE_SET`, and `ALWAYS_FORWARD_ONLY`. Ref: https://www.envoyproxy.io/docs/envoy/latest/api-v3/extensions/filters/network/http_connection_manager/v3/http_connection_manager.proto#envoy-v3-api-enum-extensions-filters-network-http-connection-manager-v3-httpconnectionmanager-forwardclientcertdetails |
| gateway.mode | string | `"local"` | Operation mode of the gateway: local or connected |
| gateway.scope | string | `"Cluster"` | Installation scope: Cluster or Namespace gateway |
| gateway.streamIdleTimeout | int | `300` | Stream idle timeout of all APIs It should be the number of seconds. |
| gateway.syncDebounceTime | string | `"5s"` | Defines the time to wait for changes before applying the configuration. It should be a duration string such as "5s". |
| image.name | string | `"mulesoft/flex-gateway:1.8.0"` |  |
| image.pullPolicy | string | `"IfNotPresent"` | Pull policy for the image. Possible values: `ifNotPresent`, `Always`, and `Never` Ref: https://kubernetes.io/docs/concepts/containers/images/#image-pull-policy |
| image.pullSecretName | string | `null` | Name of the secret that contains the Docker registry credentials The secret must exist in the same namespace as the Helm release |
| ingressClass | object | `{   "enabled": true,   "name": null,   "setAsDefault": false }` | This section refers to the creation of the `IngressClass` resource Ref: https://kubernetes.io/docs/concepts/services-networking/ingress/#ingress-class |
| ingressClass.enabled | bool | `true` | Setting enablement of `ingressClass` |
| ingressClass.name | string | `null` | Name of `ingressClass`. Name by default: <releaseName>-<namespace> |
| ingressClass.setAsDefault | bool | `false` | Setting for defining if this is the default `ingressClass` for the cluster |
| livenessProbe | object | `{   "exec": {     "command": [       "flexctl",       "probe",       "--check=liveness"     ]   },   "failureThreshold": 5,   "initialDelaySeconds": 10,   "periodSeconds": 10,   "timeoutSeconds": 10 }` | Liveness probe values Ref: https://kubernetes.io/docs/concepts/workloads/pods/pod-lifecycle/#container-probes |
| minReadySeconds | int | `0` | Setting to prevent killing Pods before they are ready |
| nodeSelector | object | `{}` | Node labels for controller Pod assignment Ref: https://kubernetes.io/docs/user-guide/node-selection/ |
| podSecurityContext | object | `{   "runAsNonRoot": true,   "runAsUser": 65534,   "seccompProfile": {     "type": "RuntimeDefault"   },   "sysctls": [     {       "name": "net.ipv4.ip_unprivileged_port_start",       "value": "0"     }   ] }` | Security context policies for controller Pods See https://kubernetes.io/docs/tasks/administer-cluster/sysctl-cluster/ for notes on enabling and using `sysctls` |
| priorityClassName | string | `""` |  |
| readinessProbe | object | `{   "exec": {     "command": [       "flexctl",       "probe",       "--check=readiness",       "--allow-api-errors",       "--allow-envoy-errors",       "--allow-policy-errors"     ]   },   "failureThreshold": 2,   "initialDelaySeconds": 10,   "periodSeconds": 10,   "timeoutSeconds": 5 }` | Readiness probe values Ref: https://kubernetes.io/docs/concepts/workloads/pods/pod-lifecycle/#container-probes |
| registerSecretName | string | `null` | Deprecated. Use `registration.secretName` |
| registration.content | string | `null` | If this field is provided, the installation creates a Kubernetes secret resource that contains the contents of the registration files. |
| registration.secretName | string | `null` | If this field is provided, registration requires that a Kubernetes secret with the given name exists. The secret must contain the content of the registration files. |
| replicaCount | int | `1` | Number of Deployment replicas |
| resources.limits.cpu | string | `"1000m"` | CPU resource limits expressed in millicores |
| resources.limits.memory | string | `"1024Mi"` | Memory resource limits |
| resources.requests.cpu | string | `"250m"` |  |
| resources.requests.memory | string | `"512Mi"` |  |
| revisionHistoryLimit | int | `10` | Rollback limit |
| service.allocateLoadBalancerNodePorts | bool | `true` | You can disable node port allocation for a Service of `type=LoadBalancer` by setting the field `allocateLoadBalancerNodePorts` to false. Ignored for Kubernetes versions older than 1.24 Ref: https://kubernetes.io/docs/concepts/services-networking/service/#load-balancer-nodeport-allocation |
| service.clusterIP | string | `""` |  |
| service.enabled | bool | `true` | Boolean that indicates if a service to expose the Deployment is created |
| service.externalIPs | list | `[]` | List of IP addresses at which the service is available Ref: https://kubernetes.io/docs/user-guide/services/#external-ips |
| service.externalTrafficPolicy | string | `""` | Set external traffic policy to `local` to preserve source IP on providers supporting it Ref: https://kubernetes.io/docs/tutorials/services/source-ip/#source-ip-for-services-with-typeloadbalancer |
| service.extraAnnotations | object | `{}` |  |
| service.extraLabels | object | `{}` |  |
| service.extraPorts | list | `[]` | Additional ports to expose |
| service.healthCheckNodePort | int | `0` | Health check node port (numeric port number) for the service. If `healthCheckNodePort` isn’t specified, the service controller allocates a port from your cluster NodePort range. Ref: https://kubernetes.io/docs/tasks/access-application-cluster/create-external-load-balancer/#preserving-the-client-source-ip |
| service.http.appProtocol | bool | `false` |  |
| service.http.enabled | bool | `true` | Boolean that indicates if the HTTP port must be enabled for the service |
| service.http.nodePort | int | `0` |  |
| service.http.port | int | `80` | Service HTTP port |
| service.http.targetPort | string | `null` |  |
| service.https.appProtocol | bool | `false` |  |
| service.https.enabled | bool | `true` | Boolean that indicates if the HTTPS port must be enabled for the service |
| service.https.nodePort | int | `0` |  |
| service.https.port | int | `443` | The service HTTPS port |
| service.https.targetPort | string | `null` |  |
| service.ipFamilies | list | `[]` | List of IP families (e.g. IPv4, IPv6) assigned to the service. This field is usually assigned automatically based on cluster configuration and the `ipFamilyPolicy` field. Ref: https://kubernetes.io/docs/concepts/services-networking/dual-stack/ |
| service.ipFamilyPolicy | string | `""` | Dual-stack-ness requested or required by this service. Possible values: `SingleStack`, `PreferDualStack`, or `RequireDualStack`. `ipFamilies` and `clusterIPs` fields depend on the value of this field Ref: https://kubernetes.io/docs/concepts/services-networking/dual-stack/ |
| service.loadBalancerSourceRanges | list | `[]` | Used by cloud providers to connect the resulting `LoadBalancer` to a pre-existing static IP Ref: https://kubernetes.io/docs/concepts/services-networking/service/#loadbalancer |
| service.sessionAffinity | string | `""` | Possible settings: `None` or `ClientIP`. Kubernetes default: `None` Ref: https://kubernetes.io/docs/concepts/services-networking/service/#virtual-ips-and-service-proxies |
| service.type | string | `"LoadBalancer"` | Type of service to create Possible values: `ClusterIP`, `NodePort`, `LoadBalancer` Ref: https://kubernetes.io/docs/concepts/services-networking/service/#publishing-services-service-types |
| startupProbe | object | `{}` |  |
| terminationGracePeriodSeconds | int | `30` | Optional duration in seconds the pod needs to terminate gracefully. Ref: https://kubernetes.io/docs/reference/generated/kubernetes-api/v1.26/ |
| tolerations | list | `[]` | Node tolerations for server scheduling to nodes with taints Ref: https://kubernetes.io/docs/concepts/configuration/assign-pod-node/ |
| topologySpreadConstraints | list | `[]` | The topology spread constraints rely on the node labels to identify the topology domain(s) in which each node is. Ref: https://kubernetes.io/docs/concepts/workloads/pods/pod-topology-spread-constraints/ |
| updateStrategy | object | `{}` | Update strategy to apply to the Deployment |

