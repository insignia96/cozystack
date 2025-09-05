# Proxmox Integration Helm Chart

This Helm chart provides a complete integration solution for Proxmox VE with Kubernetes, including:

- **Cluster API Proxmox Provider**: Manages Proxmox VMs as Kubernetes nodes
- **Proxmox CSI Driver**: Provides persistent storage for Kubernetes
- **Kube-OVN + Cilium**: Advanced networking capabilities

> **Note**: Kamaji integration is handled by the CozyStack platform itself and is not included in this chart.

## Prerequisites

- Kubernetes cluster (management cluster)
- Proxmox VE server
- `helm` CLI tool
- `kubectl` CLI tool

## Installation

1. Add the Helm repository:
```bash
helm repo add cozystack https://charts.cozystack.io
helm repo update
```

2. Create a values file:
```yaml
# my-values.yaml
clusterApi:
  enabled: true
  server:
    host: "proxmox.example.com"
    port: 8006
  credentials:
    username: "your-username"
    password: "your-password"
  vm:
    template: "ubuntu-2004-template"
    node: "proxmox-node"
```

3. Install the chart:
```bash
helm install proxmox-integration cozystack/proxmox-integration \
  --namespace proxmox-integration \
  --create-namespace \
  --values my-values.yaml
```

## Configuration

### Cluster API Proxmox

```yaml
clusterApi:
  enabled: true
  server:
    host: "proxmox.example.com"
    port: 8006
    insecure: false
  credentials:
    username: "your-username"
    password: "your-password"
  vm:
    template: "ubuntu-2004-template"
    node: "proxmox-node"
    cores: 2
    memory: 4096
    diskSize: 20
```

### Proxmox CSI

```yaml
csi:
  enabled: true
  storage:
    default: "local-lvm"
    pools:
      - name: "local-lvm"
        type: "lvm"
        path: "/dev/pve"
```

### Networking

```yaml
networking:
  kubeOvn:
    enabled: true
    network:
      defaultCidr: "10.16.0.0/16"
      defaultGateway: "10.16.0.1"
  cilium:
    enabled: true
    features:
      enablePolicy: "default"
      enableHubble: true
```

### CozyStack Integration

Kamaji integration is handled by the CozyStack platform. This chart focuses on the core Proxmox integration components.

## Uninstallation

```bash
helm uninstall proxmox-integration --namespace proxmox-integration
```

## Troubleshooting

### Common Issues

1. **Cluster API Provider Not Starting**:
   - Check Proxmox credentials
   - Verify network connectivity
   - Review provider logs

2. **CSI Driver Issues**:
   - Check storage backend configuration
   - Verify Proxmox storage availability
   - Review CSI driver logs

3. **Networking Problems**:
   - Check CNI configuration
   - Verify network policies
   - Review networking logs

### Debug Commands

```bash
# Check all components
kubectl get pods -A -l app.kubernetes.io/instance=proxmox-integration

# Check Cluster API
kubectl get clusters
kubectl get machines

# Check CSI
kubectl get storageclass
kubectl get pv

# Check networking
kubectl get networkpolicies
cilium status

# Check CozyStack integration
kubectl get pods -n cozystack-system
```

## Support

For support and questions:
- GitHub Issues: https://github.com/your-org/cozystack/issues
- Documentation: https://docs.cozystack.io
- Community: https://community.cozystack.io
