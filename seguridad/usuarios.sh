#!/bin/bash
echo "[ANM] Creando usuarios del sistema..."

sudo useradd -r -s /bin/false anm-web     2>/dev/null || echo "anm-web ya existe"
sudo useradd -r -s /bin/false anm-backup  2>/dev/null || echo "anm-backup ya existe"
sudo useradd -r -s /bin/false anm-monitor 2>/dev/null || echo "anm-monitor ya existe"

sudo mkdir -p /opt/anm/{backups,logs,documentos,bin}

# SETGID en backups
# Archivos nuevos heredan grupo anm-backup sin importar quién los crea
sudo chown root:anm-backup /opt/anm/backups
sudo chmod 2775 /opt/anm/backups

# Sticky bit en logs
# Solo el dueño de cada archivo puede borrarlo
sudo chown root:anm-monitor /opt/anm/logs
sudo chmod 1775 /opt/anm/logs

# SETUID en script de monitoreo
# Se ejecuta con permisos de anm-monitor aunque lo llame otro usuario
sudo cp scripts/monitoreo.sh /opt/anm/bin/monitoreo
sudo chown anm-monitor:anm-monitor /opt/anm/bin/monitoreo
sudo chmod 4755 /opt/anm/bin/monitoreo

echo "[ANM] Permisos configurados:"
ls -la /opt/anm/
ls -la /opt/anm/bin/
echo ""
echo "Leyenda de permisos especiales:"
echo "  drwxrwsr-x = SETGID activo (s en posicion grupo)"
echo "  drwxrwxr-t = Sticky bit activo (t en posicion others)"
echo "  -rwsr-xr-x = SETUID activo (s en posicion owner)"
