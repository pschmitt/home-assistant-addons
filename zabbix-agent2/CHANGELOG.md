# [1.8.2] - 2025-12-29

## Changed

- Zabbix-Agent2 7.4.6

# [1.8.1] - 2025-12-04

## Changed

- Implemented support for multiple UserParameters
- Enabled loading other config files from zabbix_agent2.d.
- Combined agent config file additions

 ## Added

 - Added debug mode (disabled by default) and fixed typo that broke if statement

# [1.8.0] - 2025-11-11

## Changed

- Rebase container image on Alpine Edge
- Zabbix-Agent2 7.4
- Add zabbix-agent2-plugin-alpine

# [1.7.1] - 2025-01-12

## Fixed

- Fix UserParameter value check
- To detect host interface metrics container needs to run in host network

# [1.7.0] - 2025-01-11

## Fixed

- Use correct permissions for docker socket

## Changed

- Drop unnecessary permissions

## Added

- Add configurable UserParameter option

# [1.6.0] - 2025-01-10

## Changed

- Upgrade to Zabbix Agent 2 Version 7.0

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
