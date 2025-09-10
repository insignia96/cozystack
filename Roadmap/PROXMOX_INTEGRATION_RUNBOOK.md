# Proxmox Integration Runbook

## 📋 Огляд

Цей runbook містить покрокові інструкції для встановлення, налаштування та підтримки інтеграції Proxmox VE з CozyStack платформою.

## 🎯 Передумови

### Системні вимоги

#### Proxmox VE Server
- **Версія**: 7.0+ (рекомендовано 8.0+)
- **CPU**: 4+ cores (VT-x/AMD-V enabled)
- **RAM**: 8GB+ (рекомендовано 16GB+)
- **Storage**: 100GB+ для VM templates та storage pools
- **Network**: Статичний IP, доступ до Kubernetes кластера

#### Kubernetes Cluster (CozyStack)
- **Версія**: 1.26+ (рекомендовано 1.28+)
- **Nodes**: 3+ nodes (1 master + 2+ workers)
- **RAM**: 4GB+ per node
- **Storage**: 50GB+ для etcd та logs
- **Network**: Підключення до Proxmox сервера

#### Додаткові вимоги
- **kubectl**: 1.26+ версія
- **helm**: 3.8+ версія
- **python3**: 3.8+ версія
- **pytest**: для тестування
- **curl**: для API тестування

### Мережеві вимоги

#### Порти Proxmox VE
- **8006**: Web UI та API (HTTPS)
- **22**: SSH доступ
- **5900-5999**: VNC консоль (опціонально)
- **3128**: Proxmox backup server (опціонально)

#### Порти Kubernetes
- **6443**: Kubernetes API server
- **2379-2380**: etcd server
- **10250**: kubelet API
- **10251**: kube-scheduler
- **10252**: kube-controller-manager

## 🚀 Встановлення

### Крок 1: Підготовка Proxmox сервера

#### 1.1 Перевірка системи
```bash
# Перевірка версії Proxmox
pveversion -v

# Перевірка ресурсів
free -h
df -h
lscpu

# Перевірка мережі
ip addr show
ip route show
```

#### 1.2 Налаштування мережі
```bash
# Редагування мережевої конфігурації
nano /etc/network/interfaces

# Приклад конфігурації:
# auto vmbr0
# iface vmbr0 inet static
#     address 192.168.1.100/24
#     gateway 192.168.1.1
#     bridge_ports eno1
#     bridge_stp off
#     bridge_fd 0

# Перезапуск мережі
systemctl restart networking
```

#### 1.3 Налаштування storage pools
```bash
# Перевірка наявних storage
pvesm status

# Створення storage pool для Kubernetes
pvesm add lvm-thin proxmox-k8s --vgname pve --thinpool k8s-thin

# Або використання існуючого storage
pvesm add dir proxmox-k8s --path /var/lib/vz/k8s
```

#### 1.4 Налаштування API доступу
```bash
# Створення користувача для API
pveum user add k8s-api@pve --password 'secure-password'

# Надання дозволів
pveum role add Kubernetes --privs "VM.Allocate VM.Clone VM.Config.CDROM VM.Config.CPU VM.Config.Disk VM.Config.Hardware VM.Config.Memory VM.Config.Network VM.Config.Options VM.Monitor VM.PowerMgmt Datastore.AllocateSpace Datastore.Audit Pool.Allocate Sys.Audit Sys.Console Sys.Modify"

# Призначення ролі користувачу
pveum aclmod / --users k8s-api@pve --roles Kubernetes
```

### Крок 2: Підготовка Kubernetes кластера

#### 2.1 Перевірка CozyStack компонентів
```bash
# Перевірка namespace'ів
kubectl get namespaces | grep cozy

# Перевірка Cluster API оператора
kubectl get pods -n cozy-cluster-api

# Перевірка CAPI провайдерів
kubectl get infrastructureproviders -A
```

#### 2.2 Встановлення необхідних компонентів
```bash
# Перевірка наявності Helm charts
helm list -A | grep -E "(capi|proxmox)"

# Якщо потрібно встановити CAPI оператор
helm install capi-operator cozy-capi-operator -n cozy-cluster-api

# Встановлення CAPI провайдерів
helm install capi-providers cozy-capi-providers -n cozy-cluster-api
```

### Крок 3: Налаштування інтеграції

#### 3.1 Копіювання тестових скриптів
```bash
# Створення робочої директорії
mkdir -p /opt/proxmox-integration
cd /opt/proxmox-integration

# Копіювання з CozyStack репозиторію
cp -r /path/to/cozystack/tests/proxmox-integration/* .

# Надання прав на виконання
chmod +x *.sh
```

#### 3.2 Налаштування конфігурації
```bash
# Копіювання прикладу конфігурації
cp config.example.env config.env

# Редагування конфігурації
nano config.env
```

**Приклад config.env:**
```bash
# Proxmox Configuration
PROXMOX_HOST="192.168.1.100"
PROXMOX_PORT="8006"
PROXMOX_USERNAME="k8s-api@pve"
PROXMOX_PASSWORD="secure-password"
PROXMOX_VERIFY_SSL="true"

# Kubernetes Configuration
K8S_ENDPOINT="https://k8s-master:6443"
KUBECONFIG="/root/.kube/config"

# Test Configuration
TEST_NAMESPACE="proxmox-test"
TEST_VM_TEMPLATE="ubuntu-22.04-cloud"
TEST_STORAGE_POOL="proxmox-k8s"
TEST_NETWORK_BRIDGE="vmbr0"

# Storage Configuration
CSI_STORAGE_CLASS="proxmox-csi"
CSI_TEST_SIZE="1Gi"

# Monitoring Configuration
PROMETHEUS_ENDPOINT="http://prometheus:9090"
GRAFANA_ENDPOINT="http://grafana:3000"

# Network Configuration
CNI_PROVIDER="cilium"
NETWORK_POLICY_ENABLED="true"

# E2E Testing
E2E_ENABLE_STORAGE="true"
E2E_ENABLE_NETWORK="true"
E2E_CLEANUP_ON_FAILURE="true"
```

#### 3.3 Встановлення залежностей
```bash
# Встановлення Python залежностей
pip3 install -r requirements.txt

# Встановлення додаткових інструментів
apt-get update
apt-get install -y curl jq openssl
```

### Крок 4: Запуск тестів інтеграції

#### 4.1 Підготовка тестового середовища
```bash
# Запуск setup скрипта
./setup-test-env.sh

# Перевірка підготовки
kubectl get namespaces | grep proxmox-test
```

#### 4.2 Послідовне тестування
```bash
# Крок 1: API підключення
./run-all-tests.sh -s 1

# Крок 2: Мережа та сховище
./run-all-tests.sh -s 2

# Крок 3: VM управління
./run-all-tests.sh -s 3

# Крок 4: Worker інтеграція
./run-all-tests.sh -s 4

# Крок 5: CSI storage
./run-all-tests.sh -s 5

# Крок 6: Мережеві політики
./run-all-tests.sh -s 6

# Крок 7: Моніторинг
./run-all-tests.sh -s 7

# Крок 8: E2E тестування
./run-all-tests.sh -s 8
```

#### 4.3 Повне тестування
```bash
# Запуск всіх тестів
./run-all-tests.sh

# Запуск з детальним логуванням
./run-all-tests.sh -v

# Запуск з збереженням ресурсів для налагодження
KEEP_TEST_RESOURCES=true ./run-all-tests.sh
```

## 🔧 Налаштування компонентів

### Cluster API Proxmox Provider

#### Встановлення
```bash
# Деплой CAPI Proxmox провайдера
helm install capi-providers-proxmox cozy-capi-providers-proxmox \
  -n cozy-cluster-api \
  --set proxmox.enabled=true \
  --set kubevirt.enabled=false
```

#### Перевірка встановлення
```bash
# Перевірка CRD
kubectl get crd | grep proxmox

# Перевірка InfrastructureProvider
kubectl get infrastructureproviders

# Перевірка подів
kubectl get pods -n cozy-cluster-api | grep proxmox
```

### Proxmox Worker Node

#### Встановлення
```bash
# Деплой Proxmox worker chart
helm install proxmox-worker proxmox-worker \
  -n cozy-proxmox \
  --set proxmox.host="192.168.1.100" \
  --set proxmox.username="k8s-api@pve" \
  --set proxmox.password="secure-password"
```

#### Перевірка worker node
```bash
# Перевірка node статусу
kubectl get nodes -o wide

# Перевірка labels та taints
kubectl describe node proxmox-worker

# Перевірка pod scheduling
kubectl get pods -o wide | grep proxmox-worker
```

### CSI Storage Driver

#### Встановлення
```bash
# Деплой Proxmox CSI оператора
helm install proxmox-csi-operator cozy-proxmox-csi-operator \
  -n cozy-proxmox \
  --set proxmox.host="192.168.1.100" \
  --set proxmox.username="k8s-api@pve" \
  --set proxmox.password="secure-password"
```

#### Налаштування Storage Class
```yaml
apiVersion: storage.k8s.io/v1
kind: StorageClass
metadata:
  name: proxmox-csi
provisioner: proxmox.csi.io
parameters:
  storage: proxmox-k8s
  content: images
reclaimPolicy: Delete
allowVolumeExpansion: true
```

#### Перевірка CSI
```bash
# Перевірка CSI driver
kubectl get csidriver

# Перевірка storage class
kubectl get storageclass

# Тестування volume provisioning
kubectl apply -f - <<EOF
apiVersion: v1
kind: PersistentVolumeClaim
metadata:
  name: test-pvc
spec:
  accessModes:
    - ReadWriteOnce
  resources:
    requests:
      storage: 1Gi
  storageClassName: proxmox-csi
EOF
```

## 🔍 Моніторинг та діагностика

### Перевірка статусу компонентів

#### Proxmox сервер
```bash
# Статус сервісів
systemctl status pve-cluster
systemctl status pveproxy
systemctl status pvedaemon

# Логи
journalctl -u pve-cluster -f
journalctl -u pveproxy -f
```

#### Kubernetes кластер
```bash
# Статус подів
kubectl get pods -A | grep -E "(proxmox|capi)"

# Логи CAPI провайдера
kubectl logs -n cozy-cluster-api -l app.kubernetes.io/name=capi-providers-proxmox

# Логи CSI driver
kubectl logs -n cozy-proxmox -l app.kubernetes.io/name=proxmox-csi-operator
```

### Метрики та моніторинг

#### Prometheus метрики
```bash
# Перевірка метрик Proxmox
curl -k https://192.168.1.100:8006/api2/json/version

# Перевірка метрик Kubernetes
kubectl get --raw /metrics

# Перевірка метрик CAPI
kubectl get --raw /apis/metrics.k8s.io/v1beta1/nodes
```

#### Grafana dashboard
```bash
# Доступ до Grafana
kubectl port-forward -n cozy-monitoring svc/grafana 3000:80

# Відкрити в браузері
# http://localhost:3000
```

## 🚨 Troubleshooting

### Загальні проблеми

#### 1. API підключення не працює
```bash
# Перевірка мережевої підключенності
ping 192.168.1.100
telnet 192.168.1.100 8006

# Перевірка SSL сертифікатів
openssl s_client -connect 192.168.1.100:8006 -servername 192.168.1.100

# Тестування API
curl -k -u k8s-api@pve:secure-password https://192.168.1.100:8006/api2/json/version
```

#### 2. CAPI провайдер не встановлюється
```bash
# Перевірка CRD
kubectl get crd | grep cluster

# Перевірка подів
kubectl get pods -n cozy-cluster-api

# Логи
kubectl logs -n cozy-cluster-api -l app.kubernetes.io/name=capi-operator
```

#### 3. Worker node не приєднується
```bash
# Перевірка kubeadm конфігурації
kubectl get nodes
kubectl describe node proxmox-worker

# Перевірка join token
kubeadm token list

# Логи kubelet
journalctl -u kubelet -f
```

#### 4. CSI storage не працює
```bash
# Перевірка CSI driver
kubectl get csidriver
kubectl get pods -n cozy-proxmox

# Перевірка storage class
kubectl get storageclass
kubectl describe storageclass proxmox-csi

# Логи CSI driver
kubectl logs -n cozy-proxmox -l app.kubernetes.io/name=proxmox-csi-operator
```

### Діагностичні команди

#### Перевірка Proxmox
```bash
# Статус системи
pveversion -v
pveceph status
pvesm status

# Статус VM
qm list
qm status <vmid>

# Мережева конфігурація
cat /etc/network/interfaces
ip addr show
```

#### Перевірка Kubernetes
```bash
# Статус кластера
kubectl cluster-info
kubectl get nodes -o wide
kubectl get pods -A

# Статус CAPI
kubectl get clusters,machines,proxmoxclusters,proxmoxmachines -A

# Статус storage
kubectl get pv,pvc,storageclass
kubectl get csidriver
```

## 🔄 Обслуговування

### Регулярні завдання

#### Щоденні перевірки
```bash
# Скрипт щоденної перевірки
#!/bin/bash
echo "=== Proxmox Integration Health Check ==="

# Перевірка Proxmox API
curl -k -s -u k8s-api@pve:secure-password https://192.168.1.100:8006/api2/json/version > /dev/null
if [ $? -eq 0 ]; then
    echo "✅ Proxmox API: OK"
else
    echo "❌ Proxmox API: FAILED"
fi

# Перевірка Kubernetes API
kubectl cluster-info > /dev/null 2>&1
if [ $? -eq 0 ]; then
    echo "✅ Kubernetes API: OK"
else
    echo "❌ Kubernetes API: FAILED"
fi

# Перевірка CAPI провайдера
kubectl get infrastructureproviders > /dev/null 2>&1
if [ $? -eq 0 ]; then
    echo "✅ CAPI Provider: OK"
else
    echo "❌ CAPI Provider: FAILED"
fi

# Перевірка worker nodes
kubectl get nodes | grep proxmox-worker > /dev/null
if [ $? -eq 0 ]; then
    echo "✅ Proxmox Worker: OK"
else
    echo "❌ Proxmox Worker: FAILED"
fi

# Перевірка CSI driver
kubectl get csidriver | grep proxmox > /dev/null
if [ $? -eq 0 ]; then
    echo "✅ CSI Driver: OK"
else
    echo "❌ CSI Driver: FAILED"
fi

echo "=== Health Check Complete ==="
```

#### Тижневі завдання
- Очищення старих логів
- Перевірка дискового простору
- Оновлення backup'ів конфігурації
- Аналіз метрик та performance

#### Місячні завдання
- Оновлення компонентів
- Security audit
- Performance tuning
- Документація змін

### Backup та відновлення

#### Backup конфігурації
```bash
# Backup Proxmox конфігурації
tar -czf proxmox-config-$(date +%Y%m%d).tar.gz /etc/pve/

# Backup Kubernetes конфігурації
kubectl get all -A -o yaml > k8s-config-$(date +%Y%m%d).yaml

# Backup Helm releases
helm list -A -o yaml > helm-releases-$(date +%Y%m%d).yaml
```

#### Відновлення
```bash
# Відновлення Proxmox конфігурації
tar -xzf proxmox-config-YYYYMMDD.tar.gz -C /

# Відновлення Kubernetes ресурсів
kubectl apply -f k8s-config-YYYYMMDD.yaml

# Відновлення Helm releases
helm install -f helm-releases-YYYYMMDD.yaml
```

## 📚 Додаткові ресурси

### Документація
- [Proxmox VE Documentation](https://pve.proxmox.com/wiki/Main_Page)
- [Kubernetes Documentation](https://kubernetes.io/docs/)
- [Cluster API Documentation](https://cluster-api.sigs.k8s.io/)
- [CozyStack Documentation](https://github.com/cozystack/cozystack)

### Корисні посилання
- [Proxmox API Reference](https://pve.proxmox.com/wiki/Proxmox_VE_API)
- [Kubernetes API Reference](https://kubernetes.io/docs/reference/)
- [Cluster API Providers](https://cluster-api.sigs.k8s.io/reference/providers.html)

### Підтримка
- **GitHub Issues**: [CozyStack Repository](https://github.com/cozystack/cozystack/issues)
- **Slack**: #proxmox-integration
- **Email**: support@cozystack.io

---

**Останнє оновлення**: 2024-01-15  
**Версія**: 1.0.0  
**Автор**: CozyStack Team
