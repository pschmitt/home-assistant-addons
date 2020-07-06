#!/usr/bin/env ash

# Extract config data
CONFIG_PATH=/data/options.json
ZABBIX_SERVER=$(jq --raw-output ".server" "$CONFIG_PATH")
ZABBIX_HOSTNAME=$(jq --raw-output ".hostname" "$CONFIG_PATH")

# Update zabbix-agent config
sed -i 's/^\(Server\(Active\)\?\)=.*/\1='"${ZABBIX_SERVER}"'/' /etc/zabbix/zabbix_agentd2.conf
sed -i 's/^\(Hostname\)=.*/\1='"${ZABBIX_HOSTNAME}"'/' /etc/zabbix/zabbix_agentd2.conf

# Run zabbix-agent2 in foreground
exec su zabbix -s /bin/ash -c "zabbix_agent2 -f -v"
