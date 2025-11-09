# Advanced Bash Scripting for DevOps Engineers 🚀

This extended guide builds on Bash scripting fundamentals with **advanced concepts**, **real-world automation examples**, and **DevOps-focused projects**.

---

## ⚙️ Best Practices

Before diving into scripts, always start your script with:

```bash
#!/usr/bin/env bash
set -euo pipefail
IFS=$'\n\t'
```

- `set -e` → Exit immediately if a command exits with a non-zero status.  
- `set -u` → Treat unset variables as an error.  
- `set -o pipefail` → Return exit code of the first failed command in a pipeline.  
- `IFS` → Prevents word-splitting bugs.

---

## 🧩 Functions in Bash

Functions help organize and reuse code.

```bash
#!/usr/bin/env bash

greet_user() {
  echo "Hello, $1! Welcome to Bash scripting."
}

greet_user "Imran"
```

**Return codes**: A function can return a status code (0=success, non-zero=failure).

```bash
check_file() {
  [[ -f "$1" ]] && return 0 || return 1
}

if check_file "/etc/passwd"; then
  echo "File exists"
else
  echo "File not found"
fi
```

---

## 📚 Arrays

```bash
fruits=("apple" "banana" "cherry")
echo "First fruit: ${fruits[0]}"
echo "All fruits: ${fruits[@]}"
```

Loop through arrays:

```bash
for f in "${fruits[@]}"; do
  echo "$f"
done
```

---

## 🧮 Arithmetic Operations

```bash
x=10
y=3
echo $((x + y))
echo $((x * y))
echo $((x / y))
```

---

## ⚙️ Error Handling with `trap`

```bash
#!/usr/bin/env bash
set -euo pipefail

cleanup() {
  echo "Cleaning up before exit..."
}
trap cleanup EXIT

echo "Doing something..."
# simulate error
false
```

The `trap` command ensures cleanup even if the script fails.

---

## 🔍 Argument Parsing with `getopts`

Use `getopts` to handle flags like `-f` or `-d`.

```bash
#!/usr/bin/env bash

while getopts "f:d:" opt; do
  case ${opt} in
    f) FILE=$OPTARG;;
    d) DIR=$OPTARG;;
    *) echo "Usage: $0 -f <file> -d <dir>"; exit 1;;
  esac
done

echo "File: $FILE, Directory: $DIR"
```

Run it as:
```bash
./script.sh -f config.yaml -d /tmp
```

---

## 🧾 Logging with Timestamp

```bash
log() {
  echo "$(date +'%Y-%m-%d %H:%M:%S') [INFO] $1"
}

log "Starting backup process..."
log "Backup completed successfully."
```

---

## 📊 Disk Usage Monitor

```bash
#!/usr/bin/env bash
THRESHOLD=80
USAGE=$(df / | tail -1 | awk '{print $5}' | tr -d '%')

if (( USAGE > THRESHOLD )); then
  echo "Warning: Disk usage above ${THRESHOLD}%! Current: ${USAGE}%"
else
  echo "Disk usage normal (${USAGE}%)"
fi
```

---

## 🧹 System Cleanup Script

```bash
#!/usr/bin/env bash
LOG_DIR="/var/log"
BACKUP_DIR="/tmp/log_backup_$(date +%F)"
mkdir -p "$BACKUP_DIR"

find "$LOG_DIR" -type f -name "*.log" -mtime +7 -exec gzip {} \; -exec mv {}.gz "$BACKUP_DIR" \;
echo "Old logs compressed and moved to $BACKUP_DIR"
```

---

## 🗄️ Log Parser

Find all errors in log files and count them:

```bash
grep -i "error" /var/log/syslog | tee /tmp/error_report.txt
echo "Total errors found: $(wc -l < /tmp/error_report.txt)"
```

---

## 🌐 Deploy Script to Remote Hosts (via SSH)

```bash
#!/usr/bin/env bash
HOSTS=( "192.168.1.10" "192.168.1.11" )
COMMAND="sudo systemctl restart nginx"

for host in "${HOSTS[@]}"; do
  echo "Running on $host"
  ssh -o BatchMode=yes user@$host "$COMMAND"
done
```

---

## 🧰 Auto Restart Failed Services

```bash
#!/usr/bin/env bash
SERVICE="nginx"

if ! systemctl is-active --quiet "$SERVICE"; then
  echo "$SERVICE is down. Restarting..."
  systemctl restart "$SERVICE"
else
  echo "$SERVICE is running fine."
fi
```

You can schedule it in crontab to check every 5 minutes.

---

## ☁️ AWS CLI Integration Example

```bash
#!/usr/bin/env bash
BUCKET="my-backup-bucket"
FILE="/tmp/backup.tar.gz"

tar -czf "$FILE" /var/www
aws s3 cp "$FILE" s3://$BUCKET/
echo "Backup uploaded to S3 bucket: $BUCKET"
```

---

## 🧠 CI/CD Helper Example (Git + Docker)

```bash
#!/usr/bin/env bash
git pull origin main
docker build -t myapp:latest .
docker stop myapp || true
docker rm myapp || true
docker run -d -p 8080:80 myapp:latest
```

---

## 🧩 Summary

| Concept | Key Commands |
|----------|---------------|
| Error handling | `set -euo pipefail`, `trap` |
| Input & variables | `read`, `$@`, `getopts` |
| Loops | `for`, `while`, `until` |
| Arrays | `arr=()`, `${arr[@]}` |
| Functions | `func() { ... }` |
| Automation | Cron, SSH, AWS CLI, Docker |

---

## 🔗 Recommended Reading

- [Advanced Bash Scripting Guide (TLDP)](http://tldp.org/LDP/abs/html/)  
- [Bash Hackers Wiki](https://wiki.bash-hackers.org/)  
- [ShellCheck](https://www.shellcheck.net/) — Lint your shell scripts  

---
