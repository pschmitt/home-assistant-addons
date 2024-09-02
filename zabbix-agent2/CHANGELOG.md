# [1.5.1] - 2024-09-03

## Fixed

- Adjust configuration to upstream plugin executable name changes

# [1.5] - 2023-07-10

## Added

- Zabbix Agent 2 plugins for PostgreSQL and MongoDB

### Removed

- Due to the addition of the Zabbix Agent 2 plugins i386 and armhf support had to be removed

# [1.4] - 2023-07-09

## Changed

- Split Server and ServerActive variables, this will reset ServerActive to default, as the variable didn't exist before

## Added

- Make TLS PSK variables configurable
