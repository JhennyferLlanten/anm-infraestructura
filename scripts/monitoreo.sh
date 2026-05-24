#!/bin/bash
LOG="/opt/anm/logs/monitoreo.log"
FECHA=$(date '+%Y-%m-%d %H:%M:%S')

echo "========================================" >> $LOG
echo "[$FECHA] REPORTE DE MONITOREO ANM"       >> $LOG
echo "========================================" >> $LOG

CPU=$(top -bn1 | grep "Cpu(s)" | awk '{print $2}' | cut -d'%' -f1)
echo "CPU en uso: $CPU%"                        >> $LOG

RAM=$(free -m | awk 'NR==2{printf "Usado: %sMB / Total: %sMB (%.1f%%)", $3,$2,$3*100/$2}')
echo "RAM — $RAM"                               >> $LOG

DISCO=$(df -h / | awk 'NR==2{print "Usado: "$3" / Total: "$2" ("$5")"}')
echo "Disco / — $DISCO"                         >> $LOG

echo "--- Contenedores ---"                     >> $LOG
docker ps --format "{{.Names}}: {{.Status}}"    >> $LOG

CAIDOS=$(docker ps -a --filter "status=exited" --format "{{.Names}}" | wc -l)
if [ "$CAIDOS" -gt 0 ]; then
    echo "*** ALERTA: $CAIDOS contenedor(es) detenido(s) ***" >> $LOG
    docker ps -a --filter "status=exited" --format "{{.Names}}" >> $LOG
fi

if [ -f /proc/mdstat ]; then
    echo "--- Estado RAID ---"                  >> $LOG
    cat /proc/mdstat | grep -E "md|active"      >> $LOG
fi
echo "" >> $LOG
