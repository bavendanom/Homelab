#!/bin/bash
# ============================================================
#  install-docker.sh
#  Instala Docker y Docker Compose en Raspberry Pi OS (64-bit)
#  Uso: chmod +x install-docker.sh && ./install-docker.sh
# ============================================================

set -e  # Detener si algo falla

echo "=========================================="
echo "  Instalación de Docker para Raspberry Pi"
echo "=========================================="
echo ""

# ---- 1. Verificar que estamos en una Pi ----
if ! grep -qi "raspberry\|BCM" /proc/cpuinfo 2>/dev/null && \
   ! grep -qi "Raspberry" /proc/device-tree/model 2>/dev/null; then
    echo "⚠  No se detectó una Raspberry Pi."
    echo "   Este script está diseñado para Raspberry Pi OS."
    read -p "   ¿Continuar de todos modos? (s/N): " resp
    [[ "$resp" != "s" && "$resp" != "S" ]] && exit 1
fi

# ---- 2. Actualizar el sistema ----
echo "📦 Actualizando paquetes del sistema..."
sudo apt update && sudo apt upgrade -y

# ---- 3. Instalar dependencias básicas ----
echo "📦 Instalando dependencias..."
sudo apt install -y \
    ca-certificates \
    curl \
    gnupg \
    lsb-release \
    git

# ---- 4. Verificar si Docker ya está instalado ----
if command -v docker &>/dev/null; then
    echo ""
    echo "✅ Docker ya está instalado:"
    docker --version
    echo ""
else
    # ---- 5. Instalar Docker con el script oficial ----
    echo "🐳 Instalando Docker..."
    curl -fsSL https://get.docker.com -o /tmp/get-docker.sh
    sudo sh /tmp/get-docker.sh
    rm /tmp/get-docker.sh
    echo ""
    echo "✅ Docker instalado:"
    docker --version
fi

# ---- 6. Agregar tu usuario al grupo docker ----
#    Esto permite correr docker sin sudo
if groups "$USER" | grep -q '\bdocker\b'; then
    echo "✅ Tu usuario ($USER) ya está en el grupo docker."
else
    echo "👤 Agregando $USER al grupo docker..."
    sudo usermod -aG docker "$USER"
    echo ""
    echo "⚠  IMPORTANTE: Necesitas cerrar sesión y volver a entrar"
    echo "   para que el cambio de grupo tome efecto."
    echo "   Ejecuta: exit"
    echo "   Y luego reconéctate por SSH."
fi

# ---- 7. Verificar Docker Compose ----
echo ""
if docker compose version &>/dev/null; then
    echo "✅ Docker Compose disponible:"
    docker compose version
else
    echo "⚠  Docker Compose no se detectó."
    echo "   En versiones recientes viene integrado con Docker."
    echo "   Si no funciona después de reiniciar, instálalo con:"
    echo "   sudo apt install docker-compose-plugin"
fi

# ---- 8. Habilitar Docker para que arranque con la Pi ----
echo ""
echo "🔧 Habilitando Docker para inicio automático..."
sudo systemctl enable docker
sudo systemctl start docker

# ---- 9. Verificación final ----
echo ""
echo "=========================================="
echo "  Instalación completada"
echo "=========================================="
echo ""
echo "Próximos pasos:"
echo "  1. Cierra sesión y vuelve a entrar (exit + SSH)"
echo "  2. Verifica con: docker run hello-world"
echo "  3. Ve a la carpeta pihole/ y sigue el README.md"
echo ""
