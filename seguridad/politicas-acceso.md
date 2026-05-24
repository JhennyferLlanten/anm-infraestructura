# Políticas de Acceso — Infraestructura TI ANM

## Principio de mínimo privilegio
Cada usuario y proceso tiene únicamente los permisos necesarios para su función.

## Matriz de acceso

| Usuario | Puede acceder a | No puede acceder a |
|---|---|---|
| anm-admin | Todo el sistema | — |
| anm-web | /opt/anm/logs (lectura) | /opt/anm/backups, datos |
| anm-backup | /opt/anm/backups (escritura), DB dump | Resto del sistema |
| anm-monitor | /opt/anm/logs (escritura), métricas | Datos de producción |

## Acceso SSH
- Solo mediante llave criptográfica ED25519
- Login con contraseña: DESHABILITADO
- Login como root: DESHABILITADO
- Máximo 3 intentos fallidos → bloqueo 1 hora (fail2ban)
- Máximo 2 sesiones simultáneas por usuario

## Acceso a servicios
- Portal web puerto 80: público
- Grafana puerto 3000: solo red local 192.168.0.0/16
- Prometheus puerto 9090: solo red local
- PostgreSQL puerto 5432: solo contenedores red servidores
- Samba puerto 445: autenticación requerida

## Contraseñas
- Mínimo 8 caracteres con mayúsculas, minúsculas, números y caracteres especiales
- Rotación cada 90 días
- No reutilizar las últimas 5 contraseñas
