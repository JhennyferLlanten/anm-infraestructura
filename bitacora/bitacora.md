# Bitácora del Proyecto — Infraestructura TI ANM

## Día 1 — Instalación y diseño

### Entorno configurado
- SO: Ubuntu Server 22.04 LTS en VirtualBox
- RAM: 4 GB, CPUs: 2, Disco: 30 GB
- Docker, Docker Compose, Git, htop, openssh-server instalados

### Tareas realizadas
- Diseño de red con 3 zonas: DMZ, Servidores, Administración
- Creación de estructura completa del proyecto
- docker-compose.yml con 9 servicios correctamente segmentados
- Archivo .env con credenciales separadas del código

### Decisiones técnicas
- Node.js sobre Apache: API REST y servidor web en un solo proceso
- PostgreSQL sobre MySQL: soporte ACID para registros con validez legal
- Prometheus + Grafana + Loki: stack completo de observabilidad
- RAID 1: redundancia crítica para expedientes mineros

## Día 2 — Implementación de servicios

### Tareas realizadas
- PostgreSQL con tabla titulos_mineros y datos de ejemplo
- API REST con endpoints GET y POST /api/titulos
- Formulario web institucional conectado a la DB
- Sistema de logs de inserciones con marcas de tiempo

### Problemas encontrados y soluciones
- cadvisor falla en VirtualBox por filesystem de solo lectura
  Solución: eliminado del proyecto; node-exporter cubre las métricas necesarias
- anm-web quedaba en estado "Created" sin arrancar
  Causa: faltaba el volumen web_logs en el docker-compose
  Solución: agregar volumes: web_logs:/app/logs al servicio web

## Día 3 — Seguridad y automatización

### Tareas realizadas
- UFW configurado: deny all + reglas específicas por servicio y zona
- fail2ban instalado: bloqueo tras 3 intentos fallidos SSH
- SSH configurado con llaves ED25519, contraseña deshabilitada
- Usuarios de servicio sin shell: anm-web, anm-backup, anm-monitor
- Permisos especiales: SETUID en monitoreo, SETGID en backups, sticky bit en logs
- Scripts: backup.sh, monitoreo.sh, deploy.sh
- Cron: backup diario 2 AM, monitoreo cada 5 minutos
- Políticas de acceso documentadas

## Día 4 — RAID, LVM y monitoreo avanzado

### Tareas realizadas
- 2 discos virtuales de 5 GB agregados en VirtualBox
- RAID 1 configurado con mdadm, sincronización verificada
- LVM con 4 volúmenes: lv-datos (2G), lv-web (1G), lv-backups (1G), lv-logs (500M)
- Loki + Promtail para logs de inserciones visibles en Grafana
- Grafana con data sources Prometheus y Loki configurados
- Dashboard Node Exporter Full importado (ID 1860)
- Repositorio Git subido a GitHub con commits estructurados

### Problemas encontrados y soluciones
- Loki fallaba con esquema antiguo (boltdb-shipper)
  Solución: actualizar a schema v13 con sección common de la nueva versión
- Promtail no veía los logs del contenedor web
  Causa: los logs vivían dentro del contenedor sin volumen compartido
  Solución: volumen web_logs montado en anm-web y anm-promtail
