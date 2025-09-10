# Bash Script for Process Monitoring

This project contains a set of files to monitor a process named 'test' on a Linux system using a bash script and systemd timers.

## Features

- Runs every minute.
- Checks if the process is running and sends an API call.
- Logs process restarts and API server failures to `/var/log/monitoring.log`.

## Installation

1. Place `process_monitoring.sh` in `/usr/local/bin/`.
2. Place `monitoring.service` and `monitoring.timer` in `/etc/systemd/system/`.
3. Place `monitoring` config in `/etc/logrotate.d/`.
4. Run `sudo systemctl daemon-reload && sudo systemctl enable --now monitoring.timer`.
