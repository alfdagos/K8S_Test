# Spring Boot Kubernetes ConfigMap Demo

[![Java 17](https://img.shields.io/badge/Java-17-orange.svg)](https://www.oracle.com/java/technologies/javase-jdk17-downloads.html)
[![Spring Boot 3.4.11](https://img.shields.io/badge/Spring%20Boot-3.4.11-brightgreen.svg)](https://spring.io/projects/spring-boot)
[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)

Un'applicazione dimostrativa Spring Boot che illustra l'integrazione con Kubernetes ConfigMaps, mostrando come gestire configurazioni esterne in un ambiente containerizzato.

## 📋 Indice

- [Caratteristiche](#-caratteristiche)
- [Architettura](#-architettura)
- [Prerequisiti](#-prerequisiti)
- [Installazione Locale](#-installazione-locale)
- [Deployment su Kubernetes](#-deployment-su-kubernetes)
- [Test dell'Applicazione](#-test-dellapplicazione)
- [Configurazione](#-configurazione)
- [Monitoring](#-monitoring)
- [Sviluppo](#-sviluppo)
- [Contribuire](#-contribuire)
- [Licenza](#-licenza)

## 🚀 Caratteristiche

- **Spring Boot 3.4.11** con Java 17
- **Integrazione Kubernetes ConfigMaps** - Gestione configurazioni esterne
- **Health Checks** tramite Spring Boot Actuator
- **Container Security** - Esecuzione con utente non-privilegiato
- **Multi-stage Docker Build** - Immagini ottimizzate per produzione
- **Jib Integration** - Build containerless per CI/CD
- **Production-Ready** - Configurazioni ottimizzate per ambienti di produzione

## 🏗️ Architettura

```
┌─────────────────┐     ┌──────────────────┐     ┌─────────────────┐
│   ConfigMap     │────▶│  Spring Boot App │────▶│   REST API      │
│   (k8s.yaml)    │     │   (testk8s)      │     │   /hello        │
└─────────────────┘     └──────────────────┘     └─────────────────┘
                                │
                                ▼
                        ┌──────────────────┐
                        │  Actuator        │
                        │  /actuator/*     │
                        └──────────────────┘
```

L'applicazione dimostra:
- **Caricamento configurazioni** da file `application.properties` interno
- **Override dinamico** tramite Kubernetes ConfigMap montato come volume
- **Esposizione di endpoint** REST per verificare le configurazioni caricate
- **Health checks** per monitoring della salute dell'applicazione

## 📋 Prerequisiti

### Per lo sviluppo locale:
- Java 17 o superiore
- Maven 3.6+ o utilizzare il Maven wrapper incluso
- Docker (per containerizzazione)

### Per deployment su Kubernetes:
- Kubernetes cluster (v1.20+)
- kubectl configurato per accedere al cluster
- Docker registry per le immagini (opzionale per test locali)

## 💻 Installazione Locale

### 1. Clone del repository
```bash
git clone https://github.com/alfdagos/K8S_Test.git
cd K8S_Test
```

### 2. Build dell'applicazione
```bash
# Usando Maven wrapper (raccomandato)
./mvnw clean package

# O usando Maven installato localmente
mvn clean package
```

### 3. Esecuzione locale
```bash
# Esecuzione diretta con Maven
./mvnw spring-boot:run

# O esecuzione del JAR compilato
java -jar target/testk8s-1.0.0.jar
```

L'applicazione sarà disponibile su `http://localhost:8080`

### 4. Build immagine Docker

#### Opzione A: Dockerfile tradizionale
```bash
docker build -t k8s-demo/testk8s:1.0.0 .
```

#### Opzione B: Google Jib (build senza Docker daemon)
```bash
./mvnw jib:dockerBuild
```

#### Opzione C: Dockerfile ottimizzato
```bash
docker build -f Dockerfile.optimized -t k8s-demo/testk8s:optimized .
```

## ☸️ Deployment su Kubernetes

### 1. Creare il namespace (opzionale)
```bash
kubectl apply -f namespace.yaml
```

### 2. Deploy dell'applicazione
```bash
kubectl apply -f deployment_testk8s.yaml
```

Questo comando creerà:
- **ConfigMap** `config-testk8s` con configurazioni personalizzate
- **Deployment** con 1 replica dell'applicazione
- **Service** NodePort per esporre l'applicazione

### 3. Verificare il deployment
```bash
# Verificare che i pod siano in running
kubectl get pods -l app=testk8s

# Verificare i servizi
kubectl get svc testk8s

# Verificare i log
kubectl logs -l app=testk8s
```

### 4. Accesso all'applicazione

#### Su cluster locale (minikube, kind, docker-desktop):
```bash
# Ottenere l'URL del servizio
kubectl get nodes -o wide
# L'applicazione sarà disponibile su http://NODE_IP:30000
```

#### Su cluster cloud:
```bash
# Ottenere l'IP esterno del nodo
kubectl get nodes -o wide
# Accedere tramite http://EXTERNAL_IP:30000
```

## 🧪 Test dell'Applicazione

### Endpoint disponibili:

1. **Applicazione principale**: `GET /`
   ```bash
   curl http://localhost:8080/
   # Risposta: "Hello Anna" (valore dal ConfigMap)
   ```

2. **Health Check**: `GET /actuator/health`
   ```bash
   curl http://localhost:8080/actuator/health
   # Risposta: {"status":"UP"}
   ```

3. **Info applicazione**: `GET /actuator/info`
   ```bash
   curl http://localhost:8080/actuator/info
   ```

### Test con ConfigMap personalizzata:

1. Modificare il ConfigMap:
   ```bash
   kubectl edit configmap config-testk8s
   # Cambiare k8s.configmap.name da "Anna" a un altro valore
   ```

2. Riavviare il pod per ricaricare la configurazione:
   ```bash
   kubectl rollout restart deployment testk8s
   ```

3. Verificare la nuova configurazione:
   ```bash
   curl http://NODE_IP:30000/
   ```

## ⚙️ Configurazione

### Proprietà dell'applicazione

#### `application.properties`
```properties
k8s.application.name=App
management.endpoints.web.exposure.include=health,info,prometheus
management.endpoint.health.show-details=when-authorized
```

#### ConfigMap Kubernetes
```yaml
k8s.configmap.name=Anna  # Questo valore sovrascrive quello locale
```

### Variabili d'ambiente supportate

| Variabile | Descrizione | Default |
|-----------|-------------|---------|
| `SERVER_PORT` | Porta server | `8080` |
| `LOGGING_LEVEL_ROOT` | Livello di logging | `INFO` |
| `MANAGEMENT_ENDPOINTS_WEB_EXPOSURE_INCLUDE` | Endpoint Actuator esposti | `health,info` |

## 📊 Monitoring

L'applicazione include Spring Boot Actuator per il monitoring:

- **Health Checks**: `/actuator/health`
- **Metrics**: `/actuator/metrics`
- **Info**: `/actuator/info`
- **Prometheus**: `/actuator/prometheus` (se abilitato)

### Configurazione Prometheus (opzionale)

Aggiungere al `application.properties`:
```properties
management.endpoints.web.exposure.include=health,info,prometheus
management.metrics.export.prometheus.enabled=true
```

## 🛠️ Sviluppo

### Struttura del progetto
```
src/
├── main/
│   ├── java/it/alf/testk8s/
│   │   ├── Testk8sApplication.java      # Main Spring Boot class
│   │   ├── ConfigMapInfo.java           # Configuration properties
│   │   └── controller/
│   │       └── HelloWorldController.java # REST controller
│   └── resources/
│       ├── application.properties       # Configurazioni base
│       └── configmap.properties         # Configurazioni ConfigMap
└── test/
    └── java/it/alf/testk8s/
        └── Testk8sApplicationTests.java # Test di base
```

### Comandi di sviluppo utili

```bash
# Esecuzione in modalità sviluppo con hot-reload
./mvnw spring-boot:run -Dspring-boot.run.profiles=dev

# Esecuzione dei test
./mvnw test

# Build senza test
./mvnw clean package -DskipTests

# Analisi delle dipendenze
./mvnw dependency:tree

# Aggiornamento delle dipendenze
./mvnw versions:display-dependency-updates
```

### Profili Spring

- `default`: Configurazione per ambiente locale
- `dev`: Configurazione per sviluppo con debug abilitato
- `prod`: Configurazione per produzione

## 🐛 Troubleshooting

### Problemi comuni:

#### 1. Pod in stato CrashLoopBackOff
```bash
# Verificare i log del pod
kubectl logs -l app=testk8s

# Verificare la descrizione del pod
kubectl describe pod -l app=testk8s
```

#### 2. ConfigMap non caricata
```bash
# Verificare che il ConfigMap esista
kubectl get configmap config-testk8s -o yaml

# Verificare il mount nel pod
kubectl exec -it <pod-name> -- ls -la /root/
```

#### 3. Servizio non raggiungibile
```bash
# Verificare che il service sia attivo
kubectl get svc testk8s

# Verificare gli endpoint
kubectl get endpoints testk8s
```

## 📈 Roadmap

- [ ] Aggiungere test di integrazione con Testcontainers
- [ ] Implementare configurazione multi-ambiente
- [ ] Aggiungere metriche personalizzate
- [ ] Integrazione con Istio service mesh
- [ ] Helm chart per deployment semplificato

## 🤝 Contribuire

Le contribuzioni sono benvenute! Per contribuire:

1. Fork del repository
2. Creare un branch per la feature (`git checkout -b feature/AmazingFeature`)
3. Commit delle modifiche (`git commit -m 'Add some AmazingFeature'`)
4. Push del branch (`git push origin feature/AmazingFeature`)
5. Aprire una Pull Request

## 📄 Licenza

Questo progetto è distribuito sotto licenza MIT. Vedere il file `LICENSE` per i dettagli.

## 👤 Autore

**Alf** - [alfdagos](https://github.com/alfdagos)

## 🙏 Riconoscimenti

- [Spring Boot](https://spring.io/projects/spring-boot) per il framework
- [Kubernetes](https://kubernetes.io/) per l'orchestrazione
- La community open source per l'ispirazione

---

⭐ **Se questo progetto ti è stato utile, lascia una stella!** ⭐