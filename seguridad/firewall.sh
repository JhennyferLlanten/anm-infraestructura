#!/bin/bash
echo "[ANM] Configurando firewall UFW..."

sudo ufw --force reset
sudo ufw default deny incoming
sudo ufw default allow outgoing

sudo ufw allow 22/tcp   comment 'SSH administracion ANM'
sudo ufw allow 80/tcp   comment 'Portal web ANM'
sudo ufw allow 445/tcp  comment 'Samba documentos ANM'

sudo ufw allow from 192.168.0.0/16 to any port 3000 comment 'Grafana red local'
sudo ufw allow from 192.168.0.0/16 to any port 9090 comment 'Prometheus red local'
sudo ufw allow from 192.168.0.0/16 to any port 3100 comment 'Loki interno'

sudo ufw --force enable
echo "[ANM] Firewall configurado"
sudo ufw status verbose
