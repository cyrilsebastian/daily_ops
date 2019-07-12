#!/bin/bash


HOSTNAME_WEB=`hostname`
HOSTNAME_CELERY=`hostname`
#checks for CPU, RAM, disk and other services.
MEMORY=`free -m | awk 'NR==2{printf "Memory Usage: %s/%sMB %.2f%\n", $3,$2,$3*100/$2 }' | awk '{print $4}' | cut -d. -f1`
DISK=`df -h | awk '$NF=="/"{printf "Disk Usage: %d/%dGB %s\n", $3,$2,$5}' | awk '{print $4}'| sed 's/%//g'`
CPU=`top -bn1 | grep load | awk '{printf "CPU Load: %.2f\n", $(NF-2)}' | awk '{print $3}'`
RSYSLOG_STATUS=`systemctl is-active rsyslog >/dev/null 2>&1 && echo YES || echo NO`
NGINX_STATUS=`systemctl is-active nginx >/dev/null 2>&1 && echo YES || echo NO`
SUPERVISOR_STATUS=`systemctl is-active supervisord.service >/dev/null 2>&1 && echo YES || echo NO`
#UWSGI_STATUS=`systemctl is-active --quiet uwsgi && echo UWSGI is running`
UWSGI_STATUS=`systemctl is-active uwsgi >/dev/null 2>&1 && echo YES || echo NO`


if [[ $HOSTNAME_WEB == *web* ]]; then
  echo $HOSTNAME_WEB
  if [[ $DISK > 40 ]]; then
    echo "$HOSTNAME_WEB - free disk is low"
  elif [[ $MEMORY > 50  ]]; then
    echo "$HOSTNAME_WEB - High memory usage"
  elif [[ $CPU > 10 ]]; then
    echo "$HOSTNAME_WEB - High CPU usage"
  elif [[ $NGINX_STATUS == NO ]]; then
    echo "NGINX is not working"
  elif [[ $RSYSLOG_STATUS == NO ]]; then
    echo "RSYSLOG is not working "
  elif [[ $UWSGI_STATUS == NO ]]; then
    echo "UWSGI is not working"
  fi
elif [[ $HOSTNAME_CELERY == *celery* ]]; then
  echo $HOSTNAME_CELERY
  if [[ $DISK > 40 ]]; then
      echo "$HOSTNAME_CELERY - free disk is low"
  elif [[ $MEMORY > 50  ]]; then
    echo "$HOSTNAME_CELERY - High memory usage"
  elif [[ $CPU > 10 ]]; then
    echo "$HOSTNAME_CELERY - High CPU usage"
  elif [[ $SUPERVISOR_STATUS == NO ]]; then
    echo "NGINX is not working"
  elif [[ $RSYSLOG_STATUS == NO ]]; then
    echo "RSYSLOG is not working"
  fi
fi
