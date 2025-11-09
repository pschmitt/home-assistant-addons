# [1.7.0] - 2025-11-09

## Changed

- Always building with latest version of Alpine
- Always building with latest version of Zabbix-Agent
- Update and upgrade apk packages when building
- Update and upgrade apk packages when the addon starts

# [1.6.1] - 2025-01-12

## Fixed

- Fix UserParameter value check
- To detect host interface metrics container needs to run in host network

# [1.6.0] - 2025-01-11

## Changed

- Drop unnecessary permissions

## Added

- Add configurable UserParameter option

# [1.5] - 2023-07-09

## Changed

- Split Server and ServerActive variables, this will reset ServerActive to default, as the variable didn't exist before

## Added

- Make TLS PSK variables configurable
