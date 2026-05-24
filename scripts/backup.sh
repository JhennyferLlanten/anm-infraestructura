#!/bin/bash
FECHA=$(date +%Y%m%d_%H%M%S)
BACKUP_DIR="/opt/anm/backups"
LOG="/opt/anm/logs/backup.log"

echo "[$FECHA] ====== Iniciando backup ANM ======" | tee -a $LOG

docker exec anm-db pg_dump -U anm_user anm_mineria > $BACKUP_DIR/db_$FECHA.sql
if [ $? -eq 0 ]; then
    gzip $BACKUP_DIR/db_$FECHA.sql
    echo "[$FECHA] DB respaldada: db_$FECHA.sql.gz" | tee -a $LOG
else
    echo "[$FECHA] ERROR: Fallo el backup de la DB" | tee -a $LOG
fi

docker run --rm \
  -v anm-infraestructura_db_data:/data \
  -v $BACKUP_DIR:/backup \
  ubuntu tar czf /backup/volumes_$FECHA.tar.gz /data 2>/dev/null
echo "[$FECHA] Volumenes respaldados" | tee -a $LOG

find $BACKUP_DIR -name "*.sql.gz" -mtime +7 -delete
find $BACKUP_DIR -name "*.tar.gz" -mtime +7 -delete
echo "[$FECHA] Limpieza de backups antiguos completada" | tee -a $LOG
echo "[$FECHA] ====== Backup completado ======" | tee -a $LOG
ls -lh $BACKUP_DIR | tee -a $LOG
