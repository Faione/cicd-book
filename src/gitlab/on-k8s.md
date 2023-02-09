# On K8s

## Server

TODO

## Runner

[start runner in k8s cluster](https://docs.gitlab.com/runner/install/kubernetes.html)

```
NAME_SPACE=gitlab-runner 
VALUES=values.yaml

helm repo add gitlab https://charts.gitlab.io

helm -n $NAME_SPACE install --create-namespace gitlab-runner -f $VALUES gitlab/gitlab-runner

kubectl -n $NAME_SPACE apply -f cluster_role.yaml
```

clusterRole for default gitlab service account

```yaml
# cluster_role.yaml
apiVersion: rbac.authorization.k8s.io/v1
kind: ClusterRoleBinding
metadata:
  name: gitlab-runner-cd
subjects:
- kind: ServiceAccount
  name: default
  namespace: gitlab-runner
roleRef:
  kind: ClusterRole
  name: cluster-admin
  apiGroup: rbac.authorization.k8s.io

```

```yaml
# values.yaml
affinity: {}
checkInterval: 30
concurrent: 10
configMaps: {}
gitlabUrl: http://172.16.31.36:23456
hostAliases: []
image:
  image: gitlab-org/gitlab-runner
  registry: registry.gitlab.com
imagePullPolicy: IfNotPresent
metrics:
  enabled: false
  port: 9252
  portName: metrics
  serviceMonitor:
    enabled: false
nodeSelector: {}
podAnnotations: {}
podLabels: {}
podSecurityContext:
  fsGroup: 65533
  runAsUser: 100
priorityClassName: ""
rbac:
  create: false
  podSecurityPolicy:
    enabled: false
    resourceNames:
    - gitlab-runner
  rules: []
  serviceAccountName: default
resources: {}
runnerRegistrationToken: WG8Boxdsdba_kAWaJbDt
runners:
  builds: {}
  cache: {}
  config: |
    [[runners]]
      [runners.kubernetes]
        namespace = "{{.Release.Namespace}}"
        image = "ubuntu:16.04"
  helpers: {}
  locked: false
  name: 1038-k8s-runner
  services: {}
  tags: k8s, 1038
secrets: []
securityContext:
  allowPrivilegeEscalation: false
  capabilities:
    drop:
    - ALL
  privileged: false
  readOnlyRootFilesystem: false
  runAsNonRoot: true
service:
  enabled: false
  type: ClusterIP
sessionServer:
  enabled: false
terminationGracePeriodSeconds: 3600
tolerations: []
volumeMounts: []
volumes: []
```