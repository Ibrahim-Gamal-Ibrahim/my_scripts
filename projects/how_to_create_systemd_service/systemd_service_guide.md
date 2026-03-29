# Systemd Service Guide

## Objective
Learn how to create and manage a systemd service, including understanding the INI structure.

---

## Step 1: Create the Script

Create the script:
```bash
sudo nano /usr/local/bin/dummy.sh
```

Paste:
```bash
#!/bin/bash

LOG_FILE="/var/log/dummy-service.log"

while true; do
  echo "$(date) - Dummy service is running..." >> "$LOG_FILE"
  sleep 10
done
```

Make it executable:
```bash
sudo chmod +x /usr/local/bin/dummy.sh
```

---

## Step 2: Prepare Log File

```bash
sudo touch /var/log/dummy-service.log
sudo chmod 644 /var/log/dummy-service.log
```

---

## Step 3: Create systemd Service File

```bash
sudo nano /etc/systemd/system/dummy.service
```

Paste:
```ini
[Unit]
Description=Dummy Background Service
After=network.target

[Service]
ExecStart=/usr/local/bin/dummy.sh
Restart=always
RestartSec=5
User=root

[Install]
WantedBy=multi-user.target
```

---

## Step 4: Reload systemd

```bash
sudo systemctl daemon-reexec
sudo systemctl daemon-reload
```

---

## Step 5: Manage the Service

Start:
```bash
sudo systemctl start dummy
```

Stop:
```bash
sudo systemctl stop dummy
```

Enable at boot:
```bash
sudo systemctl enable dummy
```

Disable:
```bash
sudo systemctl disable dummy
```

Check status:
```bash
sudo systemctl status dummy
```

---

## Step 6: Check Logs

Systemd logs:
```bash
sudo journalctl -u dummy -f
```

Application logs:
```bash
tail -f /var/log/dummy-service.log
```

---

# Understanding the INI File

Systemd service files use INI format:
- Sections: [SectionName]
- Key-value pairs: Key=Value

---

## [Unit] Section

Defines metadata and dependencies.

- Description: Human-readable name
- After: Controls startup order

Example:
```ini
[Unit]
Description=Dummy Background Service
After=network.target
```

---

## [Service] Section

Defines how the service runs.

- ExecStart: Command to run
- Restart: Restart policy
- RestartSec: Delay before restart
- User: Which user runs the service

Example:
```ini
[Service]
ExecStart=/usr/local/bin/dummy.sh
Restart=always
RestartSec=5
User=root
```

---

## [Install] Section

Defines how the service is enabled at boot.

- WantedBy: Target that triggers the service

Example:
```ini
[Install]
WantedBy=multi-user.target
```

---

# Key Concepts

- daemon-reload: Reload service files
- daemon-reexec: Restart systemd process (rarely needed)

---

# Summary

- Create script
- Create service file
- Reload systemd
- Start and enable service
- Monitor logs

This is the foundation of managing services in Linux using systemd.
