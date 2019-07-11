#!/bin/bash

#checks for CPU, RAM, disk and other services.
DISK=`free -m | awk 'NR==2{printf "Memory Usage: %s/%sMB %.2f%\n", $3,$2,$3*100/$2 }' | awk '{print $4}' | cut -d. -f1`
MEMORY=`df -h | awk '$NF=="/"{printf "Disk Usage: %d/%dGB %s\n", $3,$2,$5}' | awk '{print $4}'| sed 's/%//g'`
CPU=`top -bn1 | grep load | awk '{printf "CPU Load: %.2f\n", $(NF-2)}' | awk '{print $3}'`
RSYSLOG_STATUS=`systemctl is-active --quiet rsyslog && echo RSYSLOG is running`
NGINX_STATUS=`systemctl is-active --quiet nginx && echo NGINX is running`
SUPERVISOR_STATUS=`systemctl is-active --quiet supervisord.service && echo CELERY is running`
UWSGI_STATUS=`systemctl is-active --quiet uwsgi && echo UWSGI is running`
