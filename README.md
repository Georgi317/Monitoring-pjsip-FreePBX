# Monitoring-pjsip-FreePBX
Monitoring pjsip FreePBX

Создаете файл скрипта
nano /usr/local/bin/zabbix_asterisk_pjsip.sh

Нужно добавить два параметра в агента заббикс
nano /etc/zabbix/zabbix_agent2.conf
Сами параметры
UserParameter=asterisk.pjsip.discovery,/usr/local/bin/zabbix_asterisk_pjsip.sh discovery
UserParameter=asterisk.pjsip.status.json,/usr/local/bin/zabbix_asterisk_pjsip.sh data
После измений нужно перезагрузить агента
systemctl restart zabbix-agent2

Далее импортируем шаблон 

Создаем хост и подтягиваем шаблон и радуемся) 
