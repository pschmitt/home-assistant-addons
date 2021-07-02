# 1.10.0-7

- Fix tailscale hostname on Home Assistant OS
- Prefer the config file for hostname values
- Log a warning if no config file found

# 1.10.0-6

- Fix startup on Home Assistant OS

# 1.10.0-5

- Fix detection of whether IP forwarding is required

# 1.10.0-4

- Reduce verbosity and don't error out as easily when something fails

# 1.10.0-3

- Don't error out if IP forwarding setup fails

# 1.10.0-2

- Fix grepping for advertisements (sysctl IP forwarding setup)

# 1.10.0-1

- Always run tailscale up --reset

# 1.10.0

- Update tailscale to 1.10.0

# 1.8.3

- Update tailscale to 1.8.3
- Add support for the --exit-node-allow-lan-access flag

# 1.6.0-1

- Add support for both exit nodes advertisement and setting an exit node

# 1.6.0

- Update tailscale to 1.6.0

# 1.4.5-6

- Add ip6tables to enable IPv6 tunnelling

# 1.4.5-5

- Fix container startup
- Improved logging
- Fix startup timeout

# 1.4.5-4

- Yes, even more config parsing fixes
- Re-enable job control
- Remove debugging stuff

# 1.4.5-3

- More config parsing fixes
- Log tailscale and tailscaled commands

# 1.4.5-2

- Fix config parsing

# 1.4.5-1

- Add support for more tailscale CLI flags
- Rename config vars so that they reflect the tailscale flags

# 1.4.5

- Initial add-on release
- Tailscale package `1.4.5`
