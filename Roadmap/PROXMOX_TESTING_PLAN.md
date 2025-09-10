# Proxmox Integration Testing Plan

## 🎯 Огляд тестування

Цей документ описує комплексний план тестування інтеграції Proxmox VE з CozyStack платформою. Тестування розділене на 8 етапів, кожен з яких перевіряє конкретні аспекти інтеграції.

## 📋 Структура тестування

### Етап 1: Proxmox API Connection Testing
**Мета**: Перевірка базового підключення та аутентифікації до Proxmox VE API

#### Тестові сценарії
1. **API Connectivity Test**
   - Перевірка доступності Proxmox API endpoint
   - Тестування SSL/TLS з'єднання
   - Валідація response time (< 2 секунди)
   - Перевірка HTTP status codes

2. **Authentication Test**
   - Тестування username/password аутентифікації
   - Тестування token-based аутентифікації
   - Перевірка invalid credentials handling
   - Тестування session timeout

3. **Permission Validation Test**
   - Перевірка необхідних дозволів для Kubernetes
   - Тестування VM management permissions
   - Перевірка storage access permissions
   - Тестування network configuration permissions

#### Критерії успіху
- ✅ API доступний з response time < 2s
- ✅ Аутентифікація працює для обох методів
- ✅ Всі необхідні дозволи надані
- ✅ Error handling працює коректно

### Етап 2: Network and Storage Configuration Testing
**Мета**: Валідація мережевої та сховищної конфігурації Proxmox для Kubernetes

#### Тестові сценарії
1. **Network Configuration Test**
   - Перевірка network bridges (vmbr0+)
   - Тестування VLAN конфігурації
   - Валідація Software Defined Networks (SDN)
   - Перевірка network isolation

2. **Storage Configuration Test**
   - Перевірка storage pools для Kubernetes
   - Тестування content types (images, templates)
   - Валідація storage space availability
   - Перевірка storage permissions

3. **Resource Availability Test**
   - Перевірка CPU ресурсів
   - Тестування RAM availability
   - Валідація disk space
   - Перевірка network bandwidth

#### Критерії успіху
- ✅ Мережеві мости налаштовані правильно
- ✅ Storage pools доступні та мають достатньо місця
- ✅ Ресурси достатні для Kubernetes workloads
- ✅ Network isolation працює

### Етап 3: VM Management via Cluster API Testing
**Мета**: Тестування створення та управління VM через Cluster API Proxmox provider

#### Тестові сценарії
1. **Cluster API Components Test**
   - Перевірка CAPI operator встановлення
   - Тестування CRD registration
   - Валідація InfrastructureProvider
   - Перевірка controller deployment

2. **Proxmox Provider Test**
   - Тестування ProxmoxCluster resource creation
   - Перевірка ProxmoxMachine resource management
   - Валідація VM provisioning process
   - Тестування VM lifecycle operations

3. **VM Operations Test**
   - Створення VM з template
   - Тестування VM start/stop/restart
   - Перевірка VM configuration updates
   - Тестування VM deletion

#### Критерії успіху
- ✅ CAPI провайдер встановлений та працює
- ✅ VM створюються через Cluster API
- ✅ VM lifecycle operations працюють
- ✅ Error handling та cleanup працюють

### Етап 4: Proxmox Worker Integration Testing
**Мета**: Валідація Proxmox сервера як Kubernetes worker node

#### Тестові сценарії
1. **Worker Node Setup Test**
   - Тестування Helm chart deployment
   - Перевірка kubeadm join process
   - Валідація node registration
   - Тестування node readiness

2. **Worker Functionality Test**
   - Перевірка pod scheduling
   - Тестування resource allocation
   - Валідація node labels та taints
   - Перевірка pod execution

3. **Integration Test**
   - Тестування communication з control plane
   - Перевірка network connectivity
   - Валідація storage access
   - Тестування monitoring integration

#### Критерії успіху
- ✅ Proxmox сервер приєднався як worker node
- ✅ Pods можуть бути scheduled на worker
- ✅ Resource allocation працює правильно
- ✅ Node labels та taints налаштовані

### Етап 5: CSI Storage Integration Testing
**Мета**: Тестування persistent storage через Proxmox CSI driver

#### Тестові сценарії
1. **CSI Driver Test**
   - Перевірка CSI driver installation
   - Тестування driver health
   - Валідація driver capabilities
   - Перевірка driver logs

2. **Storage Class Test**
   - Тестування storage class creation
   - Перевірка storage class parameters
   - Валідація volume provisioning
   - Тестування volume binding

3. **Volume Operations Test**
   - Тестування dynamic volume provisioning
   - Перевірка volume mounting
   - Валідація volume expansion
   - Тестування volume snapshots

#### Критерії успіху
- ✅ CSI driver встановлений та healthy
- ✅ Storage classes створені та працюють
- ✅ Dynamic volume provisioning працює
- ✅ Volume operations виконуються успішно

### Етап 6: Network Policies Testing
**Мета**: Валідація мережевих політик та CNI інтеграції

#### Тестові сценарії
1. **CNI Integration Test**
   - Перевірка CNI plugin installation (Cilium, Kube-OVN)
   - Тестування pod networking
   - Валідація service discovery
   - Перевірка DNS resolution

2. **Network Policy Test**
   - Тестування network policy creation
   - Перевірка policy enforcement
   - Валідація traffic filtering
   - Тестування policy updates

3. **Security Test**
   - Перевірка pod-to-pod communication
   - Тестування external access
   - Валідація network isolation
   - Перевірка security policies

#### Критерії успіху
- ✅ CNI plugins працюють правильно
- ✅ Network policies застосовуються
- ✅ Pod networking працює
- ✅ Security policies діють

### Етап 7: Monitoring and Logging Testing
**Мета**: Тестування моніторингу та логування Proxmox ресурсів

#### Тестові сценарії
1. **Monitoring Stack Test**
   - Перевірка Prometheus deployment
   - Тестування Grafana setup
   - Валідація metrics collection
   - Перевірка alerting rules

2. **Proxmox Metrics Test**
   - Тестування Proxmox metrics collection
   - Перевірка node exporter
   - Валідація custom metrics
   - Тестування metrics export

3. **Logging Test**
   - Перевірка log aggregation
   - Тестування log parsing
   - Валідація log retention
   - Перевірка log search

#### Критерії успіху
- ✅ Monitoring stack працює
- ✅ Proxmox метрики збираються
- ✅ Grafana dashboard'и створені
- ✅ Logging працює правильно

### Етап 8: End-to-End Integration Testing
**Мета**: Комплексне тестування всієї інтеграції

#### Тестові сценарії
1. **Complete Workflow Test**
   - Тестування повного lifecycle workload
   - Перевірка multi-workload deployment
   - Валідація resource management
   - Тестування scaling operations

2. **Performance Test**
   - Benchmarking VM creation time
   - Тестування storage performance
   - Перевірка network throughput
   - Валідація resource utilization

3. **Reliability Test**
   - Тестування fault tolerance
   - Перевірка recovery procedures
   - Валідація backup/restore
   - Тестування upgrade procedures

#### Критерії успіху
- ✅ Всі компоненти працюють разом
- ✅ Performance відповідає вимогам
- ✅ Система надійна та стабільна
- ✅ Backup/restore працює

## 🧪 Тестове середовище

### Системні вимоги
- **Proxmox VE**: 7.0+ з 8GB+ RAM
- **Kubernetes**: 1.26+ з 3+ nodes
- **Network**: Low latency між K8s та Proxmox
- **Storage**: 100GB+ для тестових VM

### Тестові дані
- **VM Templates**: Ubuntu 22.04, CentOS 8
- **Test Workloads**: nginx, redis, postgres
- **Storage Classes**: proxmox-csi, local-storage
- **Network Policies**: deny-all, allow-specific

## 📊 Метрики тестування

### Performance Metrics
- **API Response Time**: < 2 секунди
- **VM Creation Time**: < 5 хвилин
- **Volume Provisioning**: < 30 секунд
- **Pod Startup Time**: < 2 хвилини

### Reliability Metrics
- **Test Success Rate**: > 95%
- **System Uptime**: > 99%
- **Error Rate**: < 1%
- **Recovery Time**: < 10 хвилин

### Resource Metrics
- **CPU Utilization**: < 80%
- **Memory Usage**: < 85%
- **Disk I/O**: < 70%
- **Network Bandwidth**: < 60%

## 🔧 Налаштування тестування

### Конфігурація тестів
```bash
# Основні параметри
PROXMOX_HOST="192.168.1.100"
PROXMOX_USERNAME="k8s-api@pve"
PROXMOX_PASSWORD="secure-password"
K8S_ENDPOINT="https://k8s-master:6443"

# Тестові параметри
TEST_NAMESPACE="proxmox-test"
TEST_VM_TEMPLATE="ubuntu-22.04-cloud"
TEST_STORAGE_POOL="proxmox-k8s"
TEST_NETWORK_BRIDGE="vmbr0"

# Performance параметри
PERF_VM_COUNT=10
PERF_VOLUME_SIZE="10Gi"
PERF_TEST_DURATION="300s"
```

### Запуск тестів
```bash
# Всі тести
./run-all-tests.sh

# Конкретний етап
./run-all-tests.sh -s 3

# З детальним логуванням
./run-all-tests.sh -v

# З збереженням ресурсів
KEEP_TEST_RESOURCES=true ./run-all-tests.sh
```

## 📈 Звітність

### Тестові звіти
- **Individual Test Logs**: `logs/stepX-*/test_*.log`
- **Summary Report**: `logs/test_report_TIMESTAMP.md`
- **Combined Log**: `logs/test_run_TIMESTAMP.log`
- **Performance Report**: `logs/performance_TIMESTAMP.json`

### Метрики звітів
- **Test Coverage**: Відсоток покриття тестами
- **Success Rate**: Відсоток успішних тестів
- **Performance**: Час виконання тестів
- **Issues**: Список виявлених проблем

## 🚨 Troubleshooting

### Загальні проблеми
1. **API Connection Issues**
   - Перевірка мережевої підключенності
   - Валідація SSL сертифікатів
   - Перевірка credentials

2. **CAPI Provider Issues**
   - Перевірка CRD встановлення
   - Валідація controller logs
   - Перевірка permissions

3. **Storage Issues**
   - Перевірка CSI driver
   - Валідація storage classes
   - Перевірка volume provisioning

4. **Network Issues**
   - Перевірка CNI plugins
   - Валідація network policies
   - Перевірка pod connectivity

### Debug команди
```bash
# API тестування
curl -k -u k8s-api@pve:password https://192.168.1.100:8006/api2/json/version

# CAPI перевірка
kubectl get clusters,machines,proxmoxclusters,proxmoxmachines -A

# Storage перевірка
kubectl get pv,pvc,storageclass,csidriver

# Network перевірка
kubectl get pods -o wide
kubectl get networkpolicy -A
```

## 📚 Документація

### Тестові документи
- **Test Cases**: Детальні тестові сценарії
- **Test Data**: Тестові дані та конфігурації
- **Test Results**: Результати тестування
- **Troubleshooting Guide**: Керівництво з вирішення проблем

### Оновлення документації
- Після кожного тестового циклу
- При виявленні нових проблем
- При зміні конфігурації
- При додаванні нових тестів

---

**Останнє оновлення**: 2024-01-15  
**Версія**: 1.0.0  
**Автор**: CozyStack Team
