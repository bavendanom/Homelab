# HomeLab RPi 🏠

Repositorio para desplegar y mantener servicios self-hosted en una
**Raspberry Pi 3 B+** (1 GB RAM, ARM Cortex-A53, 4 núcleos).

Cada carpeta es un servicio independiente: clonas el repo, entras a la
carpeta, copias `.env.example` → `.env`, ajustas tus valores y corres
`docker compose up -d`.

## Hardware

| Componente       | Detalle                        |
|------------------|--------------------------------|
| Modelo           | Raspberry Pi 3 B+              |
| CPU              | ARM Cortex-A53, 4 núcleos      |
| RAM              | 1 GB                           |
| SO               | Raspberry Pi OS Lite (64-bit)  |
| Almacenamiento   | microSD 32 GB + disco USB      |

## Servicios

| # | Servicio         | Estado      | RAM estimada | Carpeta        |
|---|------------------|-------------|--------------|----------------|
| 1 | Pi-hole          | ✅ Fase 1   | ~50 MB       | `pihole/`      |
| 2 | Samba (NAS)      | 🔜 Fase 2   | ~40 MB       | `samba/`       |
| 3 | WireGuard / VPN  | 🔜 Fase 3   | ~15 MB       | `wireguard/`   |
| 4 | Mosquitto (MQTT) | 🔜 Fase 4   | ~10 MB       | `mosquitto/`   |
| 5 | Grafana (OEE)    | 🔜 Fase 5   | ~130 MB      | `grafana-oee/` |
| 6 | Jellyfin         | 🔜 Fase 6   | ~300 MB      | `jellyfin/`    |

## Inicio rápido

```bash
# 1. Instalar Docker (solo la primera vez)
chmod +x scripts/install-docker.sh
./scripts/install-docker.sh

# 2. Desplegar un servicio (ejemplo: Pi-hole)
cd pihole
cp .env.example .env
nano .env                       # edita contraseña y zona horaria
docker compose up -d

# 3. Verificar
docker ps
```

## Estructura del repositorio

```
homelab-rpi/
├── README.md                 ← Este archivo
├── docs/
│   └── capacity-plan.md      ← Análisis de capacidad de la Pi
├── scripts/
│   ├── install-docker.sh     ← Instalar Docker desde cero
│   └── backup.sh             ← Backup de volúmenes (próximamente)
├── pihole/                   ← Fase 1
│   ├── docker-compose.yml
│   ├── .env.example
│   └── README.md
├── samba/                    ← Fase 2 (próximamente)
├── wireguard/                ← Fase 3 (próximamente)
├── mosquitto/                ← Fase 4 (próximamente)
├── grafana-oee/              ← Fase 5 (próximamente)
└── jellyfin/                 ← Fase 6 (próximamente)
```
