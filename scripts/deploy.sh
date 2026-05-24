#!/bin/bash
echo "================================================"
echo "  DESPLIEGUE INFRAESTRUCTURA TI — ANM"
echo "================================================"
cd ~/anm-infraestructura

echo "[1/5] Creando directorios del sistema..."
sudo mkdir -p /opt/anm/{backups,logs,documentos,bin}

echo "[2/5] Configurando usuarios y permisos..."
bash seguridad/usuarios.sh

echo "[3/5] Configurando firewall..."
bash seguridad/firewall.sh

echo "[4/5] Levantando contenedores Docker..."
docker-compose up -d --build
sleep 30

echo "[5/5] Verificando estado de servicios..."
docker ps --format "table {{.Names}}\t{{.Status}}\t{{.Ports}}"

# Si anm-web quedó en Created, iniciarlo manualmente
if ! docker ps | grep -q "anm-web.*Up"; then
    echo "[!] anm-web no arrancó automáticamente, iniciando..."
    docker start anm-web
    sleep 3
    docker logs anm-web | tail -3
fi

IP=$(hostname -I | awk '{print $1}')
echo ""
echo "================================================"
echo "  Portal web  : http://$IP"
echo "  Grafana     : http://$IP:3000"
echo "  Prometheus  : http://$IP:9090"
echo "================================================"
