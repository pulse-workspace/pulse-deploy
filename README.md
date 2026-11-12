# Pulse Platform Deployment

Production and staging deployment configurations for open-source **Pulse**.

---

## 📁 Lean Directory Structure

```
pulse-deploy/
├── Dockerfile              # Multi-stage build for open-source Pulse core
├── docker-compose.yaml     # Full infrastructure stack + Pulse
├── .env.example            # Environment variables template
├── prometheus.yaml         # Prometheus monitoring configuration (metrics via API :32011)
├── nginx/
│   └── pulse-proxy.conf    # Nginx reverse proxy configuration (ports 32001 & 32011)
├── .gitignore
└── README.md
```

---

## 🚀 Quick Start

### 1. Prepare Environment Variables
```bash
cd pulse-deploy
cp .env.example .env
```

### 2. Launch the Full Stack
```bash
docker compose up -d
```

The stack includes:
- **PostgreSQL 16**: Port `32432` (internal Docker network: `5432`)
- **NATS JetStream**: Port `32222` (monitoring: `32822`)
- **RustFS S3**: Port `32900` (Console: `32901` - default credentials: `pulse` / `pulsepulse`)
- **Pulse**:
  - WebSocket Gateway: `ws://localhost:32001`
  - REST API & Auth: `http://localhost:32011`
  - Gateway Admin: `http://localhost:32003`
  - Prometheus Metrics: `http://localhost:32011/metrics`
- **Prometheus**: `http://localhost:9090`
- **Grafana**: `http://localhost:3000` (default login: `admin` / `admin`)

---

## 🛠 Common Operations & Maintenance

- **Check container status**:
  ```bash
  docker compose ps
  ```
- **Follow application logs**:
  ```bash
  docker compose logs -f pulse
  ```
- **Stop the stack**:
  ```bash
  docker compose down
  ```
- **Reset environment & wipe volumes**:
  ```bash
  docker compose down -v
  ```
