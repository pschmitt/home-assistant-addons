#!/usr/bin/env ash

# Extract config data
CONFIG_PATH=/data/options.json
ZABBIX_SERVER=$(jq --raw-output ".server" "$CONFIG_PATH")
ZABBIX_HOSTNAME=$(jq --raw-output ".hostname" "$CONFIG_PATH")

# Update zabbix-agent config
ZABBIX_CONFIG_FILE=/etc/zabbix/zabbix_agent2.conf
sed -i 's@^#\?\s\?\(Server\(Active\)\?\)=.*@\1='"${ZABBIX_SERVER}"'@' "$ZABBIX_CONFIG_FILE"
sed -i 's/^#\?\s\?\(Hostname\)=.*$/\1='"${ZABBIX_HOSTNAME}"'/' "${ZABBIX_CONFIG_FILE}"

# Run zabbix-agent2 in foreground
exec su zabbix -s /bin/ash -c "zabbix_agent2 -f"
