# Pi-hole — Bloqueador de anuncios DNS

Pi-hole actúa como servidor DNS para toda tu red local. Cuando un
dispositivo intenta conectarse a un dominio de publicidad o rastreo,
Pi-hole lo bloquea antes de que cargue. No necesitas instalar
extensiones en cada dispositivo — funciona a nivel de red.

## Datos del servicio

| Campo               | Valor                            |
|---------------------|----------------------------------|
| Imagen Docker       | `pihole/pihole:latest`           |
| RAM estimada        | ~50 MB (idle) / ~80 MB (carga)   |
| CPU estimado        | < 5%                             |
| Puerto DNS          | 53 (TCP y UDP)                   |
| Puerto web          | 80 (panel de administración)     |
| Panel web           | `http://<IP_DE_TU_PI>/admin`     |

## Volúmenes (datos persistentes)

| Ruta en contenedor    | Ruta local              | Qué guarda                        |
|-----------------------|-------------------------|-----------------------------------|
| `/etc/pihole`         | `./data/etc-pihole`     | Config, listas de bloqueo, logs   |
| `/etc/dnsmasq.d`      | `./data/etc-dnsmasq.d`  | Configuración DNS avanzada        |

## Variables de entorno

| Variable         | Descripción                                | Valor por defecto    |
|------------------|--------------------------------------------|----------------------|
| `TZ`             | Zona horaria para logs                     | `America/Bogota`     |
| `WEBPASSWORD`    | Contraseña del panel web                   | (debes cambiarla)    |
| `PIHOLE_DNS`     | DNS upstream separados por `;`             | `1.1.1.1;8.8.8.8`   |

## Despliegue paso a paso

```bash
# 1. Entrar a la carpeta
cd ~/homelab-rpi/pihole

# 2. Crear tu archivo de configuración
cp .env.example .env

# 3. Editar la contraseña (obligatorio)
nano .env
#    Cambia WEBPASSWORD=cambiame_por_favor
#    por algo seguro, guarda con Ctrl+O, sal con Ctrl+X

# 4. Arrancar Pi-hole
docker compose up -d

# 5. Verificar que está corriendo
docker ps

# 6. Ver los logs (Ctrl+C para salir)
docker compose logs -f
```

## Verificar que funciona

```bash
# Probar una consulta DNS contra Pi-hole
dig google.com @127.0.0.1

# Probar que bloquea anuncios (debe responder 0.0.0.0)
dig ads.google.com @127.0.0.1

# Abrir el panel web desde tu navegador
# http://192.168.20.46/admin
```

## Configurar tu red para usar Pi-hole

Para que Pi-hole proteja **todos** los dispositivos de tu red, necesitas
que tu router use la IP de la Pi como servidor DNS.

**Opción A — En el router (recomendada):**

1. Entra a la configuración de tu router (generalmente `192.168.20.1`)
2. Busca la sección DHCP o DNS
3. Cambia el DNS primario a `192.168.20.46` (la IP de tu Pi)
4. DNS secundario: déjalo vacío o pon `1.1.1.1` como respaldo
5. Reinicia el router

**Opción B — Por dispositivo:**

Configura el DNS manualmente en cada dispositivo que quieras proteger,
apuntando a `192.168.20.46`.

## Comandos útiles

```bash
# Detener Pi-hole
docker compose down

# Reiniciar Pi-hole
docker compose restart

# Actualizar a la última versión
docker compose pull
docker compose up -d

# Ver cuánta RAM usa
docker stats pihole --no-stream

# Entrar al contenedor (para debug)
docker exec -it pihole bash
```

## Restaurar desde cero

Si tu Pi muere o necesitas reinstalar:

```bash
git clone <tu-repo> ~/homelab-rpi
cd ~/homelab-rpi/pihole
cp .env.example .env
nano .env
docker compose up -d
```

Los datos persistentes se recrean automáticamente. Si tenías un
backup de `./data/`, cópialo antes de arrancar.

## Seguridad

- **Cambia la contraseña por defecto** antes de arrancar el servicio.
- **No expongas el puerto 80 a internet.** El panel web es solo para
  tu red local. Si necesitas acceso remoto, usa la VPN (Fase 3).
- El archivo `.env` contiene tu contraseña. Agrégalo a `.gitignore`
  antes de subir a GitHub. Solo sube `.env.example`.

## Solución de problemas

**Puerto 53 ocupado:**
Si al arrancar ves un error de que el puerto 53 está en uso, puede
ser que `systemd-resolved` esté corriendo. Verifica con:
```bash
sudo lsof -i :53
```
Si es `systemd-resolved`, desactívalo:
```bash
sudo systemctl stop systemd-resolved
sudo systemctl disable systemd-resolved
```

**No carga el panel web:**
Verifica que el contenedor está corriendo con `docker ps`. Si aparece
como "restarting", revisa los logs con `docker compose logs`.
