{{- define "incloud-web-resources.sidebar.menu.items.namespaced" -}}
- key: marketplace
  label: Marketplace
  children:
  - key: marketplace
    label: Marketplace
    link: /openapi-ui/{clusterName}/{namespace}/factory/marketplace
- key: compute
  label: Compute
  children:
  - key: virtualmachines
    label: VirtualMachines
    link: /openapi-ui/{clusterName}/{namespace}/api-table/apps.cozystack.io/v1alpha1/virtualmachines
  - key: vminstances
    label: VM Instances
    link: /openapi-ui/{clusterName}/{namespace}/api-table/apps.cozystack.io/v1alpha1/vminstances
  - key: kuberneteses
    label: Kubernetes Clusters
    link: /openapi-ui/{clusterName}/{namespace}/api-table/apps.cozystack.io/v1alpha1/kuberneteses
- key: paas
  label: PaaS
  children:
  - key: clickhouses
    label: ClickHouse
    link: /openapi-ui/{clusterName}/{namespace}/api-table/apps.cozystack.io/v1alpha1/clickhouses
  - key: natses
    label: NATS
    link: /openapi-ui/{clusterName}/{namespace}/api-table/apps.cozystack.io/v1alpha1/natses
  - key: mysqls
    label: MySQL
    link: /openapi-ui/{clusterName}/{namespace}/api-table/apps.cozystack.io/v1alpha1/mysqls
  - key: redises
    label: Redis
    link: /openapi-ui/{clusterName}/{namespace}/api-table/apps.cozystack.io/v1alpha1/redises
  - key: rabbitmqs
    label: RabbitMQ
    link: /openapi-ui/{clusterName}/{namespace}/api-table/apps.cozystack.io/v1alpha1/rabbitmqs
  - key: postgreses
    label: Postgres
    link: /openapi-ui/{clusterName}/{namespace}/api-table/apps.cozystack.io/v1alpha1/postgreses
  - key: ferretdb
    label: FerretDB
    link: /openapi-ui/{clusterName}/{namespace}/api-table/apps.cozystack.io/v1alpha1/ferretdb
  - key: kafkas
    label: Kafka
    link: /openapi-ui/{clusterName}/{namespace}/api-table/apps.cozystack.io/v1alpha1/kafkas

- key: networking
  label: Networking
  children:
  - key: services
    label: Services
    link: /openapi-ui/{clusterName}/{namespace}/builtin-table/services
  - key: tcpbalancers
    label: TCPBalancer
    link: /openapi-ui/{clusterName}/{namespace}/api-table/apps.cozystack.io/v1alpha1/tcpbalancers
  - key: httpcaches
    label: HTTPCache
    link: /openapi-ui/{clusterName}/{namespace}/api-table/apps.cozystack.io/v1alpha1/httpcaches
  - key: vpns
    label: VPNs
    link: /openapi-ui/{clusterName}/{namespace}/api-table/apps.cozystack.io/v1alpha1/vpns

- key: storage
  label: Storage
  children:
  - key: buckets
    label: Buckets
    link: /openapi-ui/{clusterName}/{namespace}/api-table/apps.cozystack.io/v1alpha1/buckets
  - key: vmdisks
    label: VM Disks
    link: /openapi-ui/{clusterName}/{namespace}/api-table/apps.cozystack.io/v1alpha1/vmdisks
  - key: storageclasses
    label: StorageClasses
    link: /openapi-ui/{clusterName}/api-table/storage.k8s.io/v1/storageclasses

- key: usermanagement
  label: User Management
  children:
  - key: tenants
    label: Tenants
    link: /openapi-ui/{clusterName}/{namespace}/api-table/apps.cozystack.io/v1alpha1/tenants
  - key: infos
    label: Info
    link: /openapi-ui/{clusterName}/{namespace}/api-table/apps.cozystack.io/v1alpha1/infos

- key: administration
  label: Administration
  children:
    - key: monitorings
      label: Monitoring
      link: /openapi-ui/{clusterName}/{namespace}/api-table/apps.cozystack.io/v1alpha1/monitorings
    - key: etcds
      label: Etcd
      link: /openapi-ui/{clusterName}/{namespace}/api-table/apps.cozystack.io/v1alpha1/etcds
    - key: ingresses
      label: Ingress
      link: /openapi-ui/{clusterName}/{namespace}/api-table/apps.cozystack.io/v1alpha1/ingresses
    - key: seaweedfses
      label: SeaweedFS
      link: /openapi-ui/{clusterName}/{namespace}/api-table/apps.cozystack.io/v1alpha1/seaweedfses
    - key: bootboxes
      label: BootBox
      link: /openapi-ui/{clusterName}/{namespace}/api-table/apps.cozystack.io/v1alpha1/bootboxes
{{- end }}
