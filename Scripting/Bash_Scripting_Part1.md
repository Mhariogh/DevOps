# Comprehensive Bash Scripting Guide for DevOps Engineers

## Table of Contents
1. [Introduction to Scripting](#introduction-to-scripting)
2. [What is Shell Scripting?](#what-is-shell-scripting)
3. [Why Bash Scripting for DevOps?](#why-bash-scripting-for-devops)
4. [Getting Started with Bash](#getting-started-with-bash)
5. [Basic Syntax and Concepts](#basic-syntax-and-concepts)
6. [Variables and Data Types](#variables-and-data-types)
7. [Control Structures](#control-structures)
8. [Functions](#functions)
9. [File Operations](#file-operations)
10. [Text Processing](#text-processing)
11. [Error Handling and Debugging](#error-handling-and-debugging)
12. [Working with APIs and JSON](#working-with-apis-and-json)
13. [Process Management](#process-management)
14. [Networking and Remote Operations](#networking-and-remote-operations)
15. [Cron Jobs and Scheduling](#cron-jobs-and-scheduling)
16. [Performance Monitoring and Metrics](#performance-monitoring-and-metrics)
17. [Security Practices](#security-practices)
18. [Testing Bash Scripts](#testing-bash-scripts)
19. [DevOps Real-World Examples](#devops-real-world-examples)
20. [Best Practices](#best-practices)

---

## 1. Introduction to Scripting

### What is Scripting?

**Scripting** is the process of writing a series of commands in a file that can be executed automatically by an interpreter, rather than compiling code into machine language. Scripts are typically used to automate repetitive tasks, combine multiple commands, and orchestrate complex workflows.

**Key Characteristics of Scripting:**
- **Interpreted, not compiled**: Scripts are read and executed line-by-line by an interpreter
- **Quick to write and modify**: No compilation step required
- **Task automation**: Perfect for automating system administration and operational tasks
- **Glue language**: Excellent for connecting different tools and systems together

**Scripting vs. Programming:**

| Aspect | Scripting | Programming |
|--------|-----------|-------------|
| Execution | Interpreted at runtime | Compiled to machine code |
| Speed | Slower execution | Faster execution |
| Development | Rapid development | Longer development cycle |
| Use Case | Automation, system tasks | Complex applications |
| Examples | Bash, Python, PowerShell | C, C++, Java, Go |

---

## 2. What is Shell Scripting?

### Understanding the Shell

The **shell** is a command-line interface that acts as an intermediary between the user and the operating system kernel. It interprets commands and passes them to the OS for execution.

**Types of Shells:**
- **sh (Bourne Shell)**: The original Unix shell, basic but universal
- **bash (Bourne Again Shell)**: Enhanced version of sh, most popular on Linux
- **zsh (Z Shell)**: Modern shell with advanced features, default on macOS
- **ksh (Korn Shell)**: Combines features of sh and csh
- **fish (Friendly Interactive Shell)**: User-friendly with auto-suggestions

### What is Shell Scripting?

**Shell scripting** is writing a sequence of shell commands in a file (script) that can be executed as a program. These scripts automate tasks that would otherwise require typing multiple commands manually.

**Example of manual commands vs. shell script:**

**Manual approach:**
```bash
# You type these commands one by one
cd /var/log
grep "ERROR" application.log > errors.txt
wc -l errors.txt
mail -s "Error Report" admin@company.com < errors.txt
```

**Shell script approach:**
```bash
#!/bin/bash
# error_report.sh - Run once to execute all commands
cd /var/log
grep "ERROR" application.log > errors.txt
ERROR_COUNT=$(wc -l < errors.txt)
echo "Found $ERROR_COUNT errors" | mail -s "Error Report" admin@company.com
```

---

## 3. Why Bash Scripting for DevOps?

### The DevOps Perspective

DevOps engineers work at the intersection of development and operations, requiring tools that can automate infrastructure, deployments, monitoring, and incident response. Bash scripting is essential for DevOps because:

### 1. **Universal Availability**
- Pre-installed on virtually all Linux servers, containers, and cloud instances
- No additional dependencies or installations required
- Works consistently across different environments

### 2. **Infrastructure Automation**
Bash scripts can automate:
- Server provisioning and configuration
- Application deployments
- Backup and recovery operations
- Log rotation and cleanup
- Health checks and monitoring

**Example: Automated Server Health Check**
```bash
#!/bin/bash
# health_check.sh - Monitor server resources

CPU_THRESHOLD=80
MEMORY_THRESHOLD=85
DISK_THRESHOLD=90

# Check CPU usage
CPU_USAGE=$(top -bn1 | grep "Cpu(s)" | awk '{print $2}' | cut -d'%' -f1)
if (( $(echo "$CPU_USAGE > $CPU_THRESHOLD" | bc -l) )); then
    echo "WARNING: CPU usage at ${CPU_USAGE}%"
fi

# Check memory usage
MEMORY_USAGE=$(free | grep Mem | awk '{print ($3/$2) * 100.0}' | cut -d'.' -f1)
if [ "$MEMORY_USAGE" -gt "$MEMORY_THRESHOLD" ]; then
    echo "WARNING: Memory usage at ${MEMORY_USAGE}%"
fi

# Check disk usage
DISK_USAGE=$(df -h / | tail -1 | awk '{print $5}' | cut -d'%' -f1)
if [ "$DISK_USAGE" -gt "$DISK_THRESHOLD" ]; then
    echo "WARNING: Disk usage at ${DISK_USAGE}%"
fi
```

### 3. **CI/CD Pipeline Integration**
Bash scripts integrate seamlessly with:
- Jenkins pipelines
- GitLab CI/CD
- GitHub Actions
- Azure DevOps
- CircleCI, Travis CI, and others

**Example: Jenkins Build Script**
```bash
#!/bin/bash
# jenkins_build.sh - Automated build and deploy

set -e  # Exit on any error

# Build phase
echo "Building application..."
mvn clean package -DskipTests

# Test phase
echo "Running tests..."
mvn test

# Deploy phase
echo "Deploying to staging..."
scp target/*.jar deploy@staging-server:/opt/app/
ssh deploy@staging-server "sudo systemctl restart myapp"

echo "Deployment complete!"
```

### 4. **Container and Kubernetes Operations**
- Creating and managing Docker containers
- Kubernetes cluster automation
- Pod health checks and restarts
- Log aggregation from multiple containers

**Example: Docker Cleanup Script**
```bash
#!/bin/bash
# docker_cleanup.sh - Clean up unused Docker resources

echo "Removing stopped containers..."
docker container prune -f

echo "Removing dangling images..."
docker image prune -f

echo "Removing unused volumes..."
docker volume prune -f

echo "Removing unused networks..."
docker network prune -f

echo "Cleanup complete! Disk space freed:"
df -h /var/lib/docker
```

### 5. **Cloud Infrastructure Management**
- AWS CLI automation
- Azure CLI scripting
- GCP operations
- Multi-cloud deployments

**Example: AWS EC2 Backup Script**
```bash
#!/bin/bash
# ec2_snapshot.sh - Automated EC2 volume snapshots

INSTANCE_ID="i-1234567890abcdef0"
REGION="us-east-1"

# Get all volume IDs attached to the instance
VOLUME_IDS=$(aws ec2 describe-instances \
    --instance-ids $INSTANCE_ID \
    --region $REGION \
    --query 'Reservations[0].Instances[0].BlockDeviceMappings[*].Ebs.VolumeId' \
    --output text)

# Create snapshot for each volume
for VOLUME_ID in $VOLUME_IDS; do
    echo "Creating snapshot for volume $VOLUME_ID"
    aws ec2 create-snapshot \
        --volume-id $VOLUME_ID \
        --description "Automated backup $(date +%Y-%m-%d)" \
        --region $REGION
done

echo "All snapshots created successfully"
```

### 6. **Incident Response and Troubleshooting**
- Quick diagnostic scripts
- Log analysis and pattern detection
- Automated remediation actions
- Emergency rollback procedures

**Example: Application Recovery Script**
```bash
#!/bin/bash
# app_recovery.sh - Automated incident response

APP_NAME="myapp"
LOG_FILE="/var/log/${APP_NAME}.log"
ALERT_EMAIL="oncall@company.com"

# Check if application is running
if ! systemctl is-active --quiet $APP_NAME; then
    echo "ALERT: $APP_NAME is not running!"
    
    # Capture last 50 lines of logs
    tail -n 50 $LOG_FILE > /tmp/crash_logs.txt
    
    # Attempt restart
    echo "Attempting to restart $APP_NAME..."
    systemctl restart $APP_NAME
    
    # Wait and verify
    sleep 5
    if systemctl is-active --quiet $APP_NAME; then
        echo "SUCCESS: $APP_NAME restarted successfully" | \
            mail -s "$APP_NAME Auto-Recovery Success" $ALERT_EMAIL
    else
        echo "FAILURE: $APP_NAME failed to restart" | \
            mail -s "$APP_NAME Auto-Recovery Failed" -a /tmp/crash_logs.txt $ALERT_EMAIL
    fi
fi
```

### 7. **Cost Efficiency**
- No licensing costs
- Minimal resource consumption
- Fast execution
- Native to Linux/Unix environments

### 8. **Integration with DevOps Tools**
Bash works seamlessly with:
- **Configuration Management**: Ansible, Puppet, Chef
- **Monitoring**: Prometheus, Nagios, DataDog, Dynatrace
- **Log Management**: ELK Stack, Splunk
- **Version Control**: Git operations
- **Artifact Management**: Nexus, Artifactory

---

## 4. Getting Started with Bash

### Your First Bash Script

**Step 1: Create the script file**
```bash
touch hello_devops.sh
chmod +x hello_devops.sh
```

**Step 2: Write the script**
```bash
#!/bin/bash
# hello_devops.sh - My first DevOps script

echo "Hello, DevOps World!"
echo "Today is $(date)"
echo "Running on server: $(hostname)"
echo "Current user: $(whoami)"
```

**Step 3: Execute the script**
```bash
./hello_devops.sh
```

### Understanding the Shebang

The **shebang** (`#!/bin/bash`) tells the system which interpreter to use:

```bash
#!/bin/bash          # Use bash interpreter
#!/usr/bin/env bash  # Use bash from PATH (more portable)
#!/bin/sh            # Use sh interpreter (POSIX compliant)
#!/usr/bin/python3   # Use Python 3 interpreter
```

**Why use `#!/usr/bin/env bash`?**
- More portable across different systems
- Finds bash in user's PATH
- Recommended for modern scripts

---

## 5. Basic Syntax and Concepts

### Comments

```bash
#!/bin/bash

# This is a single-line comment

echo "Hello"  # Inline comment

: '
This is a
multi-line comment
block
'

<< 'COMMENT'
This is another way
to write multi-line
comments
COMMENT
```

### Command Execution

```bash
# Direct command execution
ls -la

# Command substitution (capture output)
CURRENT_DIR=$(pwd)
echo "Current directory: $CURRENT_DIR"

# Alternative syntax (deprecated, avoid)
CURRENT_DIR=`pwd`

# Execute multiple commands
cd /var/log && grep ERROR *.log || echo "No errors found"
```

### Exit Status and Return Codes

```bash
#!/bin/bash

# Every command returns an exit code
# 0 = success, non-zero = failure

ls /existing/path
echo "Exit code: $?"  # Prints 0

ls /nonexistent/path
echo "Exit code: $?"  # Prints 2 (error)

# Custom exit codes
exit 0   # Success
exit 1   # Generic failure
exit 2   # Misuse of command
```

### DevOps Example: Deployment Verification

```bash
#!/bin/bash
# deploy_verify.sh - Verify deployment success

APP_URL="http://localhost:8080/health"
MAX_RETRIES=30
RETRY_DELAY=2

echo "Verifying deployment..."

for i in $(seq 1 $MAX_RETRIES); do
    HTTP_CODE=$(curl -s -o /dev/null -w "%{http_code}" $APP_URL)
    
    if [ "$HTTP_CODE" -eq 200 ]; then
        echo "✓ Application is healthy (HTTP $HTTP_CODE)"
        exit 0
    fi
    
    echo "Attempt $i/$MAX_RETRIES: HTTP $HTTP_CODE (retrying in ${RETRY_DELAY}s...)"
    sleep $RETRY_DELAY
done

echo "✗ Deployment verification failed after $MAX_RETRIES attempts"
exit 1
```

---

## 6. Variables and Data Types

### Variable Declaration and Assignment

```bash
#!/bin/bash

# Basic variable assignment (no spaces around =)
NAME="DevOps Engineer"
AGE=30
SALARY=75000.50

# Using variables
echo "Name: $NAME"
echo "Age: $AGE"
echo "Salary: $SALARY"

# Better practice: use curly braces
echo "Hello, ${NAME}!"

# Read-only variables (constants)
readonly PI=3.14159
declare -r MAX_CONNECTIONS=100

# Attempting to change readonly variable causes error
# PI=3.14  # This will fail
```

### Environment Variables

```bash
#!/bin/bash

# System environment variables
echo "User: $USER"
echo "Home: $HOME"
echo "Path: $PATH"
echo "Shell: $SHELL"

# Set environment variable for this script
export MY_APP_ENV="production"
export DB_HOST="db.example.com"
export DB_PORT=5432

# Child processes will inherit these variables
```

### Special Variables

```bash
#!/bin/bash
# special_vars.sh

echo "Script name: $0"
echo "First argument: $1"
echo "Second argument: $2"
echo "All arguments: $@"
echo "Number of arguments: $#"
echo "Script PID: $$"
echo "Last command exit status: $?"
echo "Last background process PID: $!"
```

**Usage:**
```bash
./special_vars.sh arg1 arg2 arg3

# Output:
# Script name: ./special_vars.sh
# First argument: arg1
# Second argument: arg2
# All arguments: arg1 arg2 arg3
# Number of arguments: 3
# Script PID: 12345
```

### DevOps Example: Configuration Management

```bash
#!/bin/bash
# config_manager.sh - Manage application configuration

# Default values
APP_NAME="${APP_NAME:-myapp}"
ENVIRONMENT="${ENVIRONMENT:-development}"
LOG_LEVEL="${LOG_LEVEL:-INFO}"
MAX_MEMORY="${MAX_MEMORY:-2048m}"

# Configuration file paths
CONFIG_DIR="/etc/${APP_NAME}"
CONFIG_FILE="${CONFIG_DIR}/app.conf"

echo "Configuring ${APP_NAME} for ${ENVIRONMENT} environment"

# Create configuration
cat > "$CONFIG_FILE" << EOF
# Application Configuration
app.name=${APP_NAME}
environment=${ENVIRONMENT}
log.level=${LOG_LEVEL}
jvm.max.memory=${MAX_MEMORY}
timestamp=$(date +%Y-%m-%d\ %H:%M:%S)
EOF

echo "Configuration written to $CONFIG_FILE"
```

### Arrays

```bash
#!/bin/bash

# Indexed arrays
SERVERS=("web-01" "web-02" "web-03")
echo "First server: ${SERVERS[0]}"
echo "All servers: ${SERVERS[@]}"
echo "Number of servers: ${#SERVERS[@]}"

# Add element to array
SERVERS+=("web-04")

# Loop through array
for server in "${SERVERS[@]}"; do
    echo "Checking $server..."
    ping -c 1 $server > /dev/null && echo "  ✓ Online" || echo "  ✗ Offline"
done

# Associative arrays (requires bash 4+)
declare -A SERVER_IPS
SERVER_IPS=([web-01]="192.168.1.10" [web-02]="192.168.1.11" [db-01]="192.168.1.20")

echo "Web-01 IP: ${SERVER_IPS[web-01]}"

# Iterate over associative array
for server in "${!SERVER_IPS[@]}"; do
    echo "$server -> ${SERVER_IPS[$server]}"
done
```

### DevOps Example: Multi-Server Operations

```bash
#!/bin/bash
# multi_server_check.sh - Check status across multiple servers

declare -A SERVERS=(
    [web-01]="10.0.1.10"
    [web-02]="10.0.1.11"
    [app-01]="10.0.2.10"
    [db-01]="10.0.3.10"
)

declare -A SERVICE_PORTS=(
    [web]="80"
    [app]="8080"
    [db]="5432"
)

echo "=== Server Health Check ==="
echo "Time: $(date)"
echo

for server in "${!SERVERS[@]}"; do
    IP="${SERVERS[$server]}"
    echo "Checking $server ($IP)..."
    
    # Ping check
    if ping -c 1 -W 2 $IP &> /dev/null; then
        echo "  ✓ Network: Online"
        
        # Determine service type and check port
        if [[ $server == web-* ]]; then
            PORT=${SERVICE_PORTS[web]}
        elif [[ $server == app-* ]]; then
            PORT=${SERVICE_PORTS[app]}
        elif [[ $server == db-* ]]; then
            PORT=${SERVICE_PORTS[db]}
        fi
        
        # Port check
        if timeout 2 bash -c "echo >/dev/tcp/$IP/$PORT" 2>/dev/null; then
            echo "  ✓ Service: Port $PORT open"
        else
            echo "  ✗ Service: Port $PORT closed or unreachable"
        fi
    else
        echo "  ✗ Network: Offline"
    fi
    echo
done
```

---

## 7. Control Structures

### If-Else Statements

```bash
#!/bin/bash

# Basic if statement
if [ "$USER" = "root" ]; then
    echo "Running as root user"
fi

# If-else
if [ "$USER" = "root" ]; then
    echo "Running as root"
else
    echo "Running as regular user"
fi

# If-elif-else
DISK_USAGE=$(df -h / | tail -1 | awk '{print $5}' | sed 's/%//')

if [ $DISK_USAGE -lt 70 ]; then
    echo "✓ Disk usage is normal ($DISK_USAGE%)"
elif [ $DISK_USAGE -lt 90 ]; then
    echo "⚠ Warning: Disk usage is high ($DISK_USAGE%)"
else
    echo "✗ Critical: Disk usage is critical ($DISK_USAGE%)"
fi
```

### Comparison Operators

```bash
#!/bin/bash

# Numeric comparisons
a=10
b=20

[ $a -eq $b ]  # Equal to
[ $a -ne $b ]  # Not equal to
[ $a -lt $b ]  # Less than
[ $a -le $b ]  # Less than or equal to
[ $a -gt $b ]  # Greater than
[ $a -ge $b ]  # Greater than or equal to

# String comparisons
str1="hello"
str2="world"

[ "$str1" = "$str2" ]   # Equal
[ "$str1" != "$str2" ]  # Not equal
[ -z "$str1" ]          # String is empty
[ -n "$str1" ]          # String is not empty

# File tests
[ -e /path/to/file ]  # File exists
[ -f /path/to/file ]  # Is a regular file
[ -d /path/to/dir ]   # Is a directory
[ -r /path/to/file ]  # File is readable
[ -w /path/to/file ]  # File is writable
[ -x /path/to/file ]  # File is executable

# Modern syntax (double brackets - recommended)
[[ $a -gt $b ]]           # Numeric comparison
[[ "$str1" == "hello" ]]  # String comparison with == or =
[[ "$str1" =~ ^hel ]]     # Regex matching
```

### DevOps Example: Service Health Check

```bash
#!/bin/bash
# service_health.sh - Advanced service health check

SERVICE_NAME="nginx"
CONFIG_FILE="/etc/nginx/nginx.conf"
PID_FILE="/var/run/nginx.pid"
LOG_FILE="/var/log/nginx/error.log"

echo "=== $SERVICE_NAME Health Check ==="

# Check if service is running
if systemctl is-active --quiet $SERVICE_NAME; then
    echo "✓ Service Status: Running"
    
    # Check PID file
    if [ -f "$PID_FILE" ]; then
        PID=$(cat $PID_FILE)
        echo "✓ PID: $PID"
    fi
    
    # Check listening ports
    if ss -tuln | grep -q ':80 '; then
        echo "✓ Port 80: Listening"
    else
        echo "✗ Port 80: Not listening"
    fi
else
    echo "✗ Service Status: Stopped"
    
    # Check recent errors
    if [ -f "$LOG_FILE" ]; then
        echo "Recent errors:"
        tail -n 5 "$LOG_FILE"
    fi
    
    # Attempt to start service
    echo "Attempting to start $SERVICE_NAME..."
    if systemctl start $SERVICE_NAME; then
        echo "✓ Service started successfully"
    else
        echo "✗ Failed to start service"
        exit 1
    fi
fi

# Check configuration file
if [ -f "$CONFIG_FILE" ]; then
    if nginx -t -c "$CONFIG_FILE" &> /dev/null; then
        echo "✓ Configuration: Valid"
    else
        echo "✗ Configuration: Invalid"
        nginx -t -c "$CONFIG_FILE"
        exit 1
    fi
else
    echo "✗ Configuration file not found: $CONFIG_FILE"
    exit 1
fi

echo "=== Health check complete ==="
```

### Case Statements

```bash
#!/bin/bash
# environment_config.sh - Configure based on environment

ENVIRONMENT=$1

case $ENVIRONMENT in
    development|dev)
        echo "Setting up DEVELOPMENT environment"
        DB_HOST="localhost"
        LOG_LEVEL="DEBUG"
        ENABLE_DEBUG=true
        ;;
    
    staging|stage)
        echo "Setting up STAGING environment"
        DB_HOST="staging-db.company.com"
        LOG_LEVEL="INFO"
        ENABLE_DEBUG=false
        ;;
    
    production|prod)
        echo "Setting up PRODUCTION environment"
        DB_HOST="prod-db.company.com"
        LOG_LEVEL="WARN"
        ENABLE_DEBUG=false
        ;;
    
    *)
        echo "Unknown environment: $ENVIRONMENT"
        echo "Usage: $0 {development|staging|production}"
        exit 1
        ;;
esac

echo "DB_HOST=$DB_HOST"
echo "LOG_LEVEL=$LOG_LEVEL"
echo "ENABLE_DEBUG=$ENABLE_DEBUG"
```

### Loops

#### For Loop

```bash
#!/bin/bash

# Classic for loop
for i in 1 2 3 4 5; do
    echo "Number: $i"
done

# Range for loop
for i in {1..10}; do
    echo "Count: $i"
done

# C-style for loop
for ((i=0; i<5; i++)); do
    echo "Index: $i"
done

# Iterate over files
for file in /var/log/*.log; do
    echo "Processing $file"
    wc -l "$file"
done

# Iterate over command output
for user in $(cut -d: -f1 /etc/passwd); do
    echo "User: $user"
done
```

#### While Loop

```bash
#!/bin/bash

# Basic while loop
counter=1
while [ $counter -le 5 ]; do
    echo "Counter: $counter"
    ((counter++))
done

# Reading file line by line
while IFS= read -r line; do
    echo "Line: $line"
done < /etc/hosts

# Infinite loop with break
while true; do
    echo "Press Ctrl+C to stop"
    sleep 1
done
```

#### Until Loop

```bash
#!/bin/bash

# Until loop (opposite of while)
counter=1
until [ $counter -gt 5 ]; do
    echo "Counter: $counter"
    ((counter++))
done
```

### DevOps Example: Log Monitoring

```bash
#!/bin/bash
# log_monitor.sh - Real-time log monitoring with alerting

LOG_FILE="/var/log/application.log"
ERROR_PATTERN="ERROR|FATAL|CRITICAL"
ALERT_EMAIL="devops@company.com"
CHECK_INTERVAL=60

echo "Starting log monitor for $LOG_FILE"
echo "Checking every $CHECK_INTERVAL seconds..."

# Get current position in file
last_position=$(wc -c < "$LOG_FILE")

while true; do
    current_position=$(wc -c < "$LOG_FILE")
    
    if [ $current_position -gt $last_position ]; then
        # New content available
        new_lines=$(tail -c +$((last_position + 1)) "$LOG_FILE")
        
        # Check for errors
        error_count=$(echo "$new_lines" | grep -iE "$ERROR_PATTERN" | wc -l)
        
        if [ $error_count -gt 0 ]; then
            echo "[$(date)] ALERT: $error_count errors detected!"
            
            # Extract error lines
            echo "$new_lines" | grep -iE "$ERROR_PATTERN" | \
                mail -s "Application Errors Detected" $ALERT_EMAIL
        fi
        
        last_position=$current_position
    fi
    
    sleep $CHECK_INTERVAL
done
```

### DevOps Example: Deployment Automation

```bash
#!/bin/bash
# deploy_application.sh - Multi-stage deployment script

ENVIRONMENTS=("development" "staging" "production")
REQUIRED_FILES=("app.jar" "config.properties" "deploy.sh")
DEPLOYMENT_USER="deploy"

echo "=== Application Deployment Script ==="

# Stage 1: Pre-deployment checks
echo "Stage 1: Pre-deployment checks..."

for file in "${REQUIRED_FILES[@]}"; do
    if [ ! -f "$file" ]; then
        echo "✗ Missing required file: $file"
        exit 1
    fi
    echo "✓ Found: $file"
done

# Stage 2: Select environment
echo
echo "Stage 2: Select deployment environment"
PS3="Select environment: "
select ENV in "${ENVIRONMENTS[@]}" "Quit"; do
    case $ENV in
        "Quit")
            echo "Deployment cancelled"
            exit 0
            ;;
        "")
            echo "Invalid selection"
            ;;
        *)
            echo "Selected environment: $ENV"
            break
            ;;
    esac
done

# Stage 3: Deployment
case $ENV in
    development)
        SERVER="dev-server.company.com"
        PORT=8080
        ;;
    staging)
        SERVER="stage-server.company.com"
        PORT=8080
        ;;
    production)
        SERVER="prod-server.company.com"
        PORT=8080
        # Require confirmation for production
        read -p "Are you sure you want to deploy to PRODUCTION? (yes/no): " confirm
        if [ "$confirm" != "yes" ]; then
            echo "Deployment cancelled"
            exit 0
        fi
        ;;
esac

echo
echo "Stage 3: Deploying to $SERVER..."

# Copy files
for file in "${REQUIRED_FILES[@]}"; do
    echo "Copying $file to $SERVER..."
    scp "$file" ${DEPLOYMENT_USER}@${SERVER}:/opt/app/ || {
        echo "✗ Failed to copy $file"
        exit 1
    }
done

# Execute deployment script on remote server
echo "Executing deployment on remote server..."
ssh ${DEPLOYMENT_USER}@${SERVER} "bash /opt/app/deploy.sh" || {
    echo "✗ Deployment failed"
    exit 1
}

# Stage 4: Verification
echo
echo "Stage 4: Verifying deployment..."
sleep 5  # Wait for application to start

for attempt in {1..10}; do
    if curl -sf "http://${SERVER}:${PORT}/health" > /dev/null; then
        echo "✓ Deployment successful! Application is responding."
        exit 0
    fi
    echo "Waiting for application to start (attempt $attempt/10)..."
    sleep 3
done

echo "✗ Deployment verification failed"
exit 1
```

---

## 8. Functions

### Basic Function Syntax

```bash
#!/bin/bash

# Method 1: function keyword
function greet() {
    echo "Hello, $1!"
}

# Method 2: without function keyword (preferred)
say_goodbye() {
    echo "Goodbye, $1!"
}

# Function calls
greet "DevOps"
say_goodbye "World"
```

### Functions with Return Values

```bash
#!/bin/bash

# Return numeric exit status (0-255)
check_service() {
    if systemctl is-active --quiet "$1"; then
        return 0  # Success
    else
        return 1  # Failure
    fi
}

# Capture return status
if check_service "nginx"; then
    echo "nginx is running"
else
    echo "nginx is not running"
fi

# Return string output (use echo and command substitution)
get_timestamp() {
    echo "$(date +%Y-%m-%d_%H-%M-%S)"
}

BACKUP_FILE="backup_$(get_timestamp).tar.gz"
echo "Backup file: $BACKUP_FILE"
```

### Functions with Local Variables

```bash
#!/bin/bash

GLOBAL_VAR="I am global"

my_function() {
    local LOCAL_VAR="I am local"
    GLOBAL_VAR="Modified global"
    
    echo "Inside function:"
    echo "  Local: $LOCAL_VAR"
    echo "  Global: $GLOBAL_VAR"
}

echo "Before function:"
echo "  Global: $GLOBAL_VAR"
# echo "  Local: $LOCAL_VAR"  # Would fail - variable doesn't exist

my_function

echo "After function:"
echo "  Global: $GLOBAL_VAR"  # Shows modified value
# echo "  Local: $LOCAL_VAR"  # Would fail - out of scope
```

### DevOps Example: Reusable Utility Functions

```bash
#!/bin/bash
# devops_utils.sh - Reusable DevOps utility functions

# Color output functions
log_info() {
    echo -e "\033[0;34m[INFO]\033[0m $1"
}

log_success() {
    echo -e "\033[0;32m[SUCCESS]\033[0m $1"
}

log_warning() {
    echo -e "\033[0;33m[WARNING]\033[0m $1"
}

log_error() {
    echo -e "\033[0;31m[ERROR]\033[0m $1"
}

# Check if command exists
command_exists() {
    command -v "$1" >/dev/null 2>&1
}

# Check if running as root
require_root() {
    if [ "$EUID" -ne 0 ]; then
        log_error "This script must be run as root"
        exit 1
    fi
}

# Wait for service to be ready
wait_for_service() {
    local host=$1
    local port=$2
    local timeout=${3:-30}
    local counter=0
    
    log_info "Waiting for $host:$port to be ready..."
    
    while [ $counter -lt $timeout ]; do
        if timeout 1 bash -c "echo >/dev/tcp/$host/$port" 2>/dev/null; then
            log_success "Service $host:$port is ready"
            return 0
        fi
        ((counter++))
        sleep 1
    done
    
    log_error "Timeout waiting for $host:$port"
    return 1
}

# Create timestamped backup
create_backup() {
    local source=$1
    local backup_dir=${2:-/backups}
    local timestamp=$(date +%Y%m%d_%H%M%S)
    local filename=$(basename "$source")
    local backup_file="$backup_dir/${filename}_${timestamp}.tar.gz"
    
    log_info "Creating backup of $source..."
    
    mkdir -p "$backup_dir"
    tar -czf "$backup_file" "$source" 2>/dev/null
    
    if [ $? -eq 0 ]; then
        log_success "Backup created: $backup_file"
        echo "$backup_file"
        return 0
    else
        log_error "Backup failed"
        return 1
    fi
}

# Send notification
send_notification() {
    local subject=$1
    local message=$2
    local recipient=${3:-devops@company.com}
    
    if command_exists mail; then
        echo "$message" | mail -s "$subject" "$recipient"
        log_info "Notification sent to $recipient"
    else
        log_warning "mail command not found, skipping notification"
    fi
}

# Usage example
main() {
    log_info "Starting deployment process..."
    
    # Check prerequisites
    if ! command_exists docker; then
        log_error "Docker is not installed"
        exit 1
    fi
    
    # Wait for database
    if ! wait_for_service "localhost" 5432 30; then
        log_error "Database is not available"
        exit 1
    fi
    
    # Create backup
    backup_file=$(create_backup "/opt/app" "/backups")
    
    # Perform deployment
    log_info "Deploying application..."
    # ... deployment steps ...
    
    log_success "Deployment completed!"
    send_notification "Deployment Success" "Application deployed successfully"
}

# Run main function
main
```

---

## 9. File Operations

### Reading Files

```bash
#!/bin/bash

# Read entire file
CONTENT=$(cat /etc/hosts)
echo "$CONTENT"

# Read file line by line
while IFS= read -r line; do
    echo "Line: $line"
done < /etc/hosts

# Read with line numbers
while IFS= read -r line; do
    echo "$((++counter)): $line"
done < /etc/hosts

# Read specific number of lines
head -n 10 /var/log/syslog  # First 10 lines
tail -n 20 /var/log/syslog  # Last 20 lines

# Follow log file in real-time
tail -f /var/log/application.log
```

### Writing Files

```bash
#!/bin/bash

# Overwrite file
echo "Hello World" > file.txt

# Append to file
echo "New line" >> file.txt

# Write multiple lines
cat > config.txt << EOF
server=localhost
port=8080
timeout=30
EOF

# Write to file with variable expansion
cat > settings.conf << EOF
# Application Settings
HOSTNAME=$(hostname)
DATE=$(date)
USER=$USER
EOF
```

### File Testing and Manipulation

```bash
#!/bin/bash

FILE="/etc/hosts"

# Check file properties
[ -e "$FILE" ] && echo "File exists"
[ -f "$FILE" ] && echo "Is a regular file"
[ -d "$FILE" ] && echo "Is a directory"
[ -r "$FILE" ] && echo "Is readable"
[ -w "$FILE" ] && echo "Is writable"
[ -x "$FILE" ] && echo "Is executable"
[ -s "$FILE" ] && echo "File is not empty"
[ -L "$FILE" ] && echo "Is a symbolic link"

# Get file information
stat "$FILE"
ls -lh "$FILE"
file "$FILE"

# File operations
cp source.txt destination.txt     # Copy
mv oldname.txt newname.txt         # Move/rename
rm file.txt                        # Delete
chmod 755 script.sh                # Change permissions
chown user:group file.txt          # Change ownership
```

### DevOps Example: Log Rotation Script

```bash
#!/bin/bash
# log_rotation.sh - Rotate and compress old log files

LOG_DIR="/var/log/myapp"
RETENTION_DAYS=30
ARCHIVE_DIR="/var/log/myapp/archive"
MAX_SIZE_MB=100

log_message() {
    echo "[$(date '+%Y-%m-%d %H:%M:%S')] $1"
}

# Create archive directory if it doesn't exist
mkdir -p "$ARCHIVE_DIR"

log_message "Starting log rotation process"

# Find and rotate large log files
find "$LOG_DIR" -maxdepth 1 -name "*.log" -type f | while read -r logfile; do
    filename=$(basename "$logfile")
    filesize=$(stat -f%z "$logfile" 2>/dev/null || stat -c%s "$logfile")
    filesize_mb=$((filesize / 1024 / 1024))
    
    if [ $filesize_mb -gt $MAX_SIZE_MB ]; then
        log_message "Rotating $filename (size: ${filesize_mb}MB)"
        
        # Create timestamped archive
        timestamp=$(date +%Y%m%d_%H%M%S)
        archive_name="${filename%.log}_${timestamp}.log"
        
        # Copy and compress
        cp "$logfile" "$ARCHIVE_DIR/$archive_name"
        gzip "$ARCHIVE_DIR/$archive_name"
        
        # Truncate original log
        > "$logfile"
        
        log_message "Created archive: ${archive_name}.gz"
    fi
done

# Delete old archives
log_message "Cleaning up old archives (older than $RETENTION_DAYS days)"
find "$ARCHIVE_DIR" -name "*.gz" -type f -mtime +$RETENTION_DAYS -delete

# Calculate space savings
archive_size=$(du -sh "$ARCHIVE_DIR" | cut -f1)
log_message "Archive directory size: $archive_size"

log_message "Log rotation complete"
```

---

## 10. Text Processing

### Grep - Pattern Searching

```bash
#!/bin/bash

# Basic grep
grep "ERROR" /var/log/application.log

# Case-insensitive search
grep -i "error" /var/log/application.log

# Show line numbers
grep -n "ERROR" /var/log/application.log

# Recursive search in directory
grep -r "TODO" /opt/app/

# Invert match (show lines NOT matching)
grep -v "DEBUG" /var/log/application.log

# Extended regex
grep -E "ERROR|WARN|FATAL" /var/log/application.log

# Show context (lines before and after match)
grep -A 3 -B 3 "ERROR" /var/log/application.log  # 3 lines before and after

# Count occurrences
grep -c "ERROR" /var/log/application.log

# Show only matching part
grep -o "ERROR[0-9]\+" /var/log/application.log
```

### Sed - Stream Editor

```bash
#!/bin/bash

# Replace first occurrence on each line
sed 's/old/new/' file.txt

# Replace all occurrences (global)
sed 's/old/new/g' file.txt

# Replace in-place (modify file directly)
sed -i 's/old/new/g' file.txt

# Delete lines containing pattern
sed '/pattern/d' file.txt

# Delete blank lines
sed '/^$/d' file.txt

# Print specific lines
sed -n '10,20p' file.txt  # Lines 10-20

# Multiple operations
sed -e 's/old1/new1/g' -e 's/old2/new2/g' file.txt

# Use variables in sed
OLD="error"
NEW="warning"
sed "s/$OLD/$NEW/g" file.txt
```

### Awk - Text Processing

```bash
#!/bin/bash

# Print specific columns
awk '{print $1, $3}' file.txt

# Print with field separator
awk -F':' '{print $1, $6}' /etc/passwd

# Filter rows based on condition
awk '$3 > 100 {print $0}' data.txt

# Calculate sum of column
awk '{sum += $2} END {print sum}' numbers.txt

# Print with custom output
awk '{printf "User: %s, Shell: %s
", $1, $7}' /etc/passwd

# Pattern matching
awk '/ERROR/ {print $0}' logfile.txt

# Use BEGIN and END blocks
awk 'BEGIN {print "Report"} {print $0} END {print "Total lines:", NR}' file.txt
```

### DevOps Example: Log Analysis Script

```bash
#!/bin/bash
# log_analyzer.sh - Analyze application logs for errors and statistics

LOG_FILE="/var/log/application.log"
REPORT_FILE="/tmp/log_analysis_$(date +%Y%m%d_%H%M%S).txt"

echo "=== Log Analysis Report ===" > "$REPORT_FILE"
echo "Generated: $(date)" >> "$REPORT_FILE"
echo "Log file: $LOG_FILE" >> "$REPORT_FILE"
echo >> "$REPORT_FILE"

# 1. Overall Statistics
echo "--- Overall Statistics ---" >> "$REPORT_FILE"
total_lines=$(wc -l < "$LOG_FILE")
echo "Total log entries: $total_lines" >> "$REPORT_FILE"

# 2. Error Statistics
echo >> "$REPORT_FILE"
echo "--- Error Statistics ---" >> "$REPORT_FILE"
error_count=$(grep -c "ERROR" "$LOG_FILE")
warn_count=$(grep -c "WARN" "$LOG_FILE")
fatal_count=$(grep -c "FATAL" "$LOG_FILE")

echo "ERROR count: $error_count" >> "$REPORT_FILE"
echo "WARN count: $warn_count" >> "$REPORT_FILE"
echo "FATAL count: $fatal_count" >> "$REPORT_FILE"

# 3. Top Error Messages
echo >> "$REPORT_FILE"
echo "--- Top 10 Error Messages ---" >> "$REPORT_FILE"
grep "ERROR" "$LOG_FILE" | \
    awk -F'ERROR' '{print $2}' | \
    sort | uniq -c | sort -rn | head -10 >> "$REPORT_FILE"

# 4. Error Distribution by Hour
echo >> "$REPORT_FILE"
echo "--- Error Distribution by Hour ---" >> "$REPORT_FILE"
grep "ERROR" "$LOG_FILE" | \
    awk '{print $2}' | \
    cut -d: -f1 | \
    sort | uniq -c | \
    awk '{printf "%02d:00 - %s errors
", $2, $1}' >> "$REPORT_FILE"

# 5. Top IP Addresses (if logs contain IPs)
echo >> "$REPORT_FILE"
echo "--- Top 10 IP Addresses ---" >> "$REPORT_FILE"
grep -oE '\b([0-9]{1,3}\.){3}[0-9]{1,3}\b' "$LOG_FILE" | \
    sort | uniq -c | sort -rn | head -10 | \
    awk '{printf "%-15s %s requests
", $2, $1}' >> "$REPORT_FILE"

# 6. Response Time Statistics (if logs contain response times)
echo >> "$REPORT_FILE"
echo "--- Response Time Statistics ---" >> "$REPORT_FILE"
grep "response_time" "$LOG_FILE" | \
    grep -oE 'response_time=[0-9]+' | \
    cut -d= -f2 | \
    awk '{
        sum += $1
        if ($1 > max) max = $1
        if (min == 0 || $1 < min) min = $1
        count++
    }
    END {
        if (count > 0) {
            printf "Average: %.2f ms
", sum/count
            printf "Min: %d ms
", min
            printf "Max: %d ms
", max
        }
    }' >> "$REPORT_FILE"

# 7. Recent Fatal Errors
echo >> "$REPORT_FILE"
echo "--- Recent FATAL Errors (Last 5) ---" >> "$REPORT_FILE"
grep "FATAL" "$LOG_FILE" | tail -5 >> "$REPORT_FILE"

# Display report
cat "$REPORT_FILE"
echo
echo "Report saved to: $REPORT_FILE"

# Send email if critical errors found
if [ $fatal_count -gt 0 ] || [ $error_count -gt 100 ]; then
    mail -s "Critical Log Analysis Alert" devops@company.com < "$REPORT_FILE"
    echo "Alert email sent to devops@company.com"
fi
```

### DevOps Example: Configuration File Management

```bash
#!/bin/bash
# config_updater.sh - Update configuration files across environments

CONFIG_FILE="/etc/myapp/application.conf"
BACKUP_DIR="/etc/myapp/backups"
TIMESTAMP=$(date +%Y%m%d_%H%M%S)

# Function to backup config
backup_config() {
    mkdir -p "$BACKUP_DIR"
    cp "$CONFIG_FILE" "$BACKUP_DIR/application.conf.$TIMESTAMP"
    echo "Backup created: application.conf.$TIMESTAMP"
}

# Function to update config value
update_config() {
    local key=$1
    local new_value=$2
    
    # Check if key exists
    if grep -q "^${key}=" "$CONFIG_FILE"; then
        # Key exists, update it
        sed -i "s/^${key}=.*/${key}=${new_value}/" "$CONFIG_FILE"
        echo "Updated: $key=$new_value"
    else
        # Key doesn't exist, add it
        echo "${key}=${new_value}" >> "$CONFIG_FILE"
        echo "Added: $key=$new_value"
    fi
}

# Function to get config value
get_config() {
    local key=$1
    grep "^${key}=" "$CONFIG_FILE" | cut -d= -f2
}

# Function to remove config key
remove_config() {
    local key=$1
    sed -i "/^${key}=/d" "$CONFIG_FILE"
    echo "Removed: $key"
}

# Main execution
echo "=== Configuration Updater ==="
echo

# Create backup before making changes
backup_config
echo

# Update configurations based on environment
ENVIRONMENT=$(get_config "environment")
echo "Current environment: $ENVIRONMENT"

case $ENVIRONMENT in
    production)
        update_config "log.level" "WARN"
        update_config "db.pool.size" "50"
        update_config "cache.enabled" "true"
        ;;
    staging)
        update_config "log.level" "INFO"
        update_config "db.pool.size" "20"
        update_config "cache.enabled" "true"
        ;;
    development)
        update_config "log.level" "DEBUG"
        update_config "db.pool.size" "10"
        update_config "cache.enabled" "false"
        ;;
esac

echo
echo "Configuration updated successfully"
echo "Current configuration:"
cat "$CONFIG_FILE"
```

---

## 11. Error Handling and Debugging

### Set Options for Safety

```bash
#!/bin/bash

# Exit on error
set -e  # Exit immediately if a command exits with non-zero status

# Exit on undefined variable
set -u  # Treat unset variables as errors

# Exit on pipe failure
set -o pipefail  # Return exit status of last command in pipe that failed

# Combine all safety options
set -euo pipefail

# Alternative: use on shebang line
#!/bin/bash -euo pipefail
```

### Trap - Catching Signals and Errors

```bash
#!/bin/bash

# Cleanup function
cleanup() {
    echo "Performing cleanup..."
    rm -f /tmp/my_temp_file
    echo "Cleanup complete"
}

# Trap EXIT signal (always runs)
trap cleanup EXIT

# Trap errors
trap 'echo "Error occurred on line $LINENO"' ERR

# Trap specific signals
trap 'echo "Script interrupted"; exit 1' INT TERM

# Your script code here
echo "Running script..."
touch /tmp/my_temp_file
sleep 5
```

### Error Handling with Functions

```bash
#!/bin/bash

# Error handling function
error_exit() {
    echo "ERROR: $1" >&2
    exit "${2:-1}"  # Exit with code, default to 1
}

# Function with error handling
deploy_application() {
    echo "Starting deployment..."
    
    # Check if file exists
    [ -f "app.jar" ] || error_exit "app.jar not found" 2
    
    # Attempt deployment
    scp app.jar server:/opt/app/ || error_exit "Failed to copy files" 3
    
    # Verify deployment
    ssh server "systemctl restart myapp" || error_exit "Failed to restart service" 4
    
    echo "Deployment successful"
}

# Run with error handling
deploy_application
```

### DevOps Example: Comprehensive Error Handling

```bash
#!/bin/bash
# robust_deployment.sh - Deployment with comprehensive error handling

set -euo pipefail

# Configuration
APP_NAME="myapp"
DEPLOY_DIR="/opt/${APP_NAME}"
BACKUP_DIR="/backups/${APP_NAME}"
LOG_FILE="/var/log/${APP_NAME}_deploy.log"
SLACK_WEBHOOK="${SLACK_WEBHOOK:-}"

# Logging functions
log() {
    local level=$1
    shift
    local message="$@"
    local timestamp=$(date '+%Y-%m-%d %H:%M:%S')
    echo "[$timestamp] [$level] $message" | tee -a "$LOG_FILE"
}

log_info() {
    log "INFO" "$@"
}

log_error() {
    log "ERROR" "$@" >&2
}

log_success() {
    log "SUCCESS" "$@"
}

# Notification function
send_notification() {
    local status=$1
    local message=$2
    
    if [ -n "$SLACK_WEBHOOK" ]; then
        curl -X POST "$SLACK_WEBHOOK" \
            -H 'Content-Type: application/json' \
            -d "{\"text\": \"Deployment $status: $message\"}" \
            2>/dev/null || log_error "Failed to send Slack notification"
    fi
}

# Cleanup function
cleanup() {
    local exit_code=$?
    
    if [ $exit_code -ne 0 ]; then
        log_error "Deployment failed with exit code $exit_code"
        send_notification "FAILED" "$APP_NAME deployment failed"
        
        # Attempt rollback if backup exists
        if [ -d "$BACKUP_DIR/latest" ]; then
            log_info "Attempting rollback..."
            if rollback_deployment; then
                log_success "Rollback successful"
            else
                log_error "Rollback failed - manual intervention required!"
            fi
        fi
    else
        log_success "Deployment completed successfully"
        send_notification "SUCCESS" "$APP_NAME deployed successfully"
    fi
    
    # Cleanup temporary files
    rm -f /tmp/${APP_NAME}_*.tmp
}

# Set trap for cleanup
trap cleanup EXIT

# Rollback function
rollback_deployment() {
    log_info "Rolling back to previous version..."
    
    if [ ! -d "$BACKUP_DIR/latest" ]; then
        log_error "No backup found for rollback"
        return 1
    fi
    
    # Stop service
    systemctl stop $APP_NAME || return 1
    
    # Restore from backup
    rm -rf "$DEPLOY_DIR"
    cp -r "$BACKUP_DIR/latest" "$DEPLOY_DIR" || return 1
    
    # Start service
    systemctl start $APP_NAME || return 1
    
    # Verify service is running
    sleep 3
    systemctl is-active --quiet $APP_NAME || return 1
    
    return 0
}

# Pre-deployment checks
pre_deployment_checks() {
    log_info "Running pre-deployment checks..."
    
    # Check if running as correct user
    if [ "$(whoami)" != "deploy" ]; then
        log_error "Must run as 'deploy' user"
        return 1
    fi
    
    # Check disk space
    local available_space=$(df "$DEPLOY_DIR" | tail -1 | awk '{print $4}')
    if [ "$available_space" -lt 1048576 ]; then  # Less than 1GB
        log_error "Insufficient disk space"
        return 1
    fi
    
    # Check if required files exist
    local required_files=("app.jar" "config.yml")
    for file in "${required_files[@]}"; do
        if [ ! -f "$file" ]; then
            log_error "Required file not found: $file"
            return 1
        fi
    done
    
    # Check if service exists
    if ! systemctl list-unit-files | grep -q "${APP_NAME}.service"; then
        log_error "Service ${APP_NAME}.service not found"
        return 1
    fi
    
    log_success "All pre-deployment checks passed"
    return 0
}

# Create backup
create_backup() {
    log_info "Creating backup of current deployment..."
    
    if [ ! -d "$DEPLOY_DIR" ]; then
        log_info "No existing deployment to backup"
        return 0
    fi
    
    local timestamp=$(date +%Y%m%d_%H%M%S)
    local backup_path="$BACKUP_DIR/$timestamp"
    
    mkdir -p "$BACKUP_DIR"
    cp -r "$DEPLOY_DIR" "$backup_path" || return 1
    
    # Create symlink to latest
    rm -f "$BACKUP_DIR/latest"
    ln -s "$backup_path" "$BACKUP_DIR/latest"
    
    log_success "Backup created at $backup_path"
    return 0
}

# Deploy application
deploy() {
    log_info "Deploying application..."
    
    # Stop service
    log_info "Stopping service..."
    systemctl stop $APP_NAME || {
        log_error "Failed to stop service"
        return 1
    }
    
    # Deploy new files
    log_info "Copying new files..."
    cp app.jar "$DEPLOY_DIR/" || return 1
    cp config.yml "$DEPLOY_DIR/" || return 1
    
    # Set correct permissions
    chown -R ${APP_NAME}:${APP_NAME} "$DEPLOY_DIR"
    chmod 755 "$DEPLOY_DIR/app.jar"
    
    # Start service
    log_info "Starting service..."
    systemctl start $APP_NAME || return 1
    
    # Wait for service to be ready
    log_info "Waiting for service to be ready..."
    local max_attempts=30
    local attempt=0
    
    while [ $attempt -lt $max_attempts ]; do
        if systemctl is-active --quiet $APP_NAME; then
            if curl -sf http://localhost:8080/health > /dev/null 2>&1; then
                log_success "Service is healthy"
                return 0
            fi
        fi
        
        ((attempt++))
        log_info "Waiting for service (attempt $attempt/$max_attempts)..."
        sleep 2
    done
    
    log_error "Service failed to become healthy"
    return 1
}

# Main execution
main() {
    log_info "Starting deployment of $APP_NAME"
    
    # Run pre-deployment checks
    pre_deployment_checks || exit 1
    
    # Create backup
    create_backup || exit 1
    
    # Deploy application
    deploy || exit 1
    
    log_success "Deployment completed successfully!"
}

# Execute main function
main "$@"
```

### Debugging Techniques

```bash
#!/bin/bash

# Enable debug mode (print each command)
set -x

# Disable debug mode
set +x

# Debug specific section
set -x
echo "This will be debugged"
complex_command
set +x

# Use PS4 for better debug output
export PS4='+(${BASH_SOURCE}:${LINENO}): ${FUNCNAME[0]:+${FUNCNAME[0]}(): }'
set -x

# Verbose mode (print commands before execution)
set -v

# Check syntax without executing
bash -n script.sh

# Dry run pattern
DRY_RUN=true

if [ "$DRY_RUN" = true ]; then
    echo "Would execute: rm -rf /important/data"
else
    rm -rf /important/data
fi
```

---

## 12. Working with APIs and JSON

### Making HTTP Requests with curl

```bash
#!/bin/bash

# Basic GET request
curl https://api.example.com/users

# GET request with headers
curl -H "Authorization: Bearer $API_TOKEN" \
     -H "Content-Type: application/json" \
     https://api.example.com/users

# POST request with JSON data
curl -X POST https://api.example.com/users \
     -H "Content-Type: application/json" \
     -d '{
       "name": "John Doe",
       "email": "john@example.com"
     }'

# PUT request
curl -X PUT https://api.example.com/users/123 \
     -H "Content-Type: application/json" \
     -d '{"status": "active"}'

# DELETE request
curl -X DELETE https://api.example.com/users/123 \
     -H "Authorization: Bearer $API_TOKEN"

# Save response to file
curl -o response.json https://api.example.com/data

# Show response headers
curl -i https://api.example.com/status

# Follow redirects
curl -L https://api.example.com/redirect

# Set timeout
curl --connect-timeout 5 --max-time 10 https://api.example.com

# Ignore SSL certificate errors (use cautiously!)
curl -k https://self-signed.example.com
```

### Parsing JSON with jq

```bash
#!/bin/bash

# Install jq first:
# Ubuntu/Debian: apt-get install jq
# RHEL/CentOS: yum install jq
# macOS: brew install jq

# Sample JSON
cat > sample.json << 'EOF'
{
  "users": [
    {"id": 1, "name": "Alice", "role": "admin", "active": true},
    {"id": 2, "name": "Bob", "role": "user", "active": true},
    {"id": 3, "name": "Charlie", "role": "user", "active": false}
  ],
  "total": 3
}
EOF

# Extract specific field
jq '.total' sample.json
# Output: 3

# Extract nested field
jq '.users[0].name' sample.json
# Output: "Alice"

# Extract all names
jq '.users[].name' sample.json

# Filter based on condition
jq '.users[] | select(.active == true)' sample.json

# Filter and extract specific field
jq '.users[] | select(.role == "admin") | .name' sample.json

# Create new JSON structure
jq '.users[] | {username: .name, isActive: .active}' sample.json

# Count items
jq '.users | length' sample.json

# Get keys
jq 'keys' sample.json

# Raw output (no quotes)
jq -r '.users[0].name' sample.json
```

### DevOps Example: GitHub API Integration

```bash
#!/bin/bash
# github_repo_manager.sh - Manage GitHub repositories via API

GITHUB_TOKEN="${GITHUB_TOKEN:-}"
GITHUB_ORG="${GITHUB_ORG:-myorg}"
API_BASE="https://api.github.com"

# Check if token is set
if [ -z "$GITHUB_TOKEN" ]; then
    echo "Error: GITHUB_TOKEN environment variable not set"
    exit 1
fi

# Function to make authenticated API calls
github_api() {
    local method=$1
    local endpoint=$2
    local data=${3:-}
    
    if [ -n "$data" ]; then
        curl -s -X "$method" \
            -H "Authorization: token $GITHUB_TOKEN" \
            -H "Accept: application/vnd.github.v3+json" \
            -d "$data" \
            "${API_BASE}${endpoint}"
    else
        curl -s -X "$method" \
            -H "Authorization: token $GITHUB_TOKEN" \
            -H "Accept: application/vnd.github.v3+json" \
            "${API_BASE}${endpoint}"
    fi
}

# List all repositories
list_repos() {
    echo "=== Repositories in $GITHUB_ORG ==="
    github_api GET "/orgs/$GITHUB_ORG/repos?per_page=100" | \
        jq -r '.[] | "\(.name) - \(.description // "No description")"'
}

# Get repository details
get_repo_info() {
    local repo=$1
    echo "=== Repository: $repo ==="
    
    local info=$(github_api GET "/repos/$GITHUB_ORG/$repo")
    
    echo "Description: $(echo "$info" | jq -r '.description // "N/A"')"
    echo "Language: $(echo "$info" | jq -r '.language // "N/A"')"
    echo "Stars: $(echo "$info" | jq -r '.stargazers_count')"
    echo "Forks: $(echo "$info" | jq -r '.forks_count')"
    echo "Open Issues: $(echo "$info" | jq -r '.open_issues_count')"
    echo "Created: $(echo "$info" | jq -r '.created_at')"
    echo "Last Updated: $(echo "$info" | jq -r '.updated_at')"
}

# List open pull requests
list_open_prs() {
    local repo=$1
    echo "=== Open Pull Requests for $repo ==="
    
    github_api GET "/repos/$GITHUB_ORG/$repo/pulls?state=open" | \
        jq -r '.[] | "#\(.number): \(.title) by \(.user.login)"'
}

# Create a new repository
create_repo() {
    local repo_name=$1
    local description=$2
    local private=${3:-false}
    
    echo "Creating repository: $repo_name"
    
    local data=$(jq -n \
        --arg name "$repo_name" \
        --arg desc "$description" \
        --argjson priv "$private" \
        '{
            name: $name,
            description: $desc,
            private: $priv,
            auto_init: true
        }')
    
    local result=$(github_api POST "/orgs/$GITHUB_ORG/repos" "$data")
    
    if echo "$result" | jq -e '.name' > /dev/null; then
        echo "✓ Repository created successfully"
        echo "URL: $(echo "$result" | jq -r '.html_url')"
    else
        echo "✗ Failed to create repository"
        echo "$result" | jq -r '.message'
    fi
}

# Enable branch protection
enable_branch_protection() {
    local repo=$1
    local branch=${2:-main}
    
    echo "Enabling branch protection for $repo/$branch"
    
    local protection_rules='{
        "required_status_checks": {
            "strict": true,
            "contexts": ["ci/test"]
        },
        "enforce_admins": false,
        "required_pull_request_reviews": {
            "required_approving_review_count": 1,
            "dismiss_stale_reviews": true
        },
        "restrictions": null
    }'
    
    github_api PUT "/repos/$GITHUB_ORG/$repo/branches/$branch/protection" "$protection_rules"
    echo "✓ Branch protection enabled"
}

# Archive old repositories
archive_old_repos() {
    local days=${1:-365}
    local cutoff_date=$(date -d "$days days ago" +%Y-%m-%d 2>/dev/null || date -v-${days}d +%Y-%m-%d)
    
    echo "=== Repositories not updated since $cutoff_date ==="
    
    github_api GET "/orgs/$GITHUB_ORG/repos?per_page=100" | \
        jq -r --arg cutoff "$cutoff_date" '
            .[] | 
            select(.updated_at < $cutoff and .archived == false) | 
            "\(.name) - Last updated: \(.updated_at)"
        '
}

# Main menu
case "${1:-}" in
    list)
        list_repos
        ;;
    info)
        get_repo_info "$2"
        ;;
    prs)
        list_open_prs "$2"
        ;;
    create)
        create_repo "$2" "$3" "${4:-false}"
        ;;
    protect)
        enable_branch_protection "$2" "${3:-main}"
        ;;
    archive-check)
        archive_old_repos "${2:-365}"
        ;;
    *)
        echo "Usage: $0 {list|info|prs|create|protect|archive-check} [args]"
        echo ""
        echo "Commands:"
        echo "  list                           - List all repositories"
        echo "  info <repo>                    - Get repository information"
        echo "  prs <repo>                     - List open pull requests"
        echo "  create <name> <desc> [private] - Create new repository"
        echo "  protect <repo> [branch]        - Enable branch protection"
        echo "  archive-check [days]           - Find old repositories"
        exit 1
        ;;
esac
```

### DevOps Example: Slack Notifications

```bash
#!/bin/bash
# slack_notify.sh - Send notifications to Slack

SLACK_WEBHOOK_URL="${SLACK_WEBHOOK_URL:-}"

send_slack_message() {
    local message=$1
    local channel=${2:-#devops}
    local username=${3:-DevOps Bot}
    local emoji=${4:-:robot_face:}
    local color=${5:-good}  # good, warning, danger, or hex color
    
    if [ -z "$SLACK_WEBHOOK_URL" ]; then
        echo "Error: SLACK_WEBHOOK_URL not set"
        return 1
    fi
    
    local payload=$(jq -n \
        --arg channel "$channel" \
        --arg username "$username" \
        --arg emoji "$emoji" \
        --arg text "$message" \
        --arg color "$color" \
        '{
            channel: $channel,
            username: $username,
            icon_emoji: $emoji,
            attachments: [{
                color: $color,
                text: $text,
                footer: "DevOps Automation",
                ts: (now | floor)
            }]
        }')
    
    curl -X POST "$SLACK_WEBHOOK_URL" \
        -H 'Content-Type: application/json' \
        -d "$payload" \
        -s -o /dev/null
    
    if [ $? -eq 0 ]; then
        echo "✓ Slack notification sent"
    else
        echo "✗ Failed to send Slack notification"
    fi
}

# Send deployment notification
send_deployment_notification() {
    local status=$1
    local environment=$2
    local version=$3
    local deployer=${4:-$(whoami)}
    
    local color="good"
    local emoji=":white_check_mark:"
    
    if [ "$status" = "failed" ]; then
        color="danger"
        emoji=":x:"
    elif [ "$status" = "warning" ]; then
        color="warning"
        emoji=":warning:"
    fi
    
    local message="*Deployment $status* $emoji
Environment: \`$environment\`
Version: \`$version\`
Deployed by: $deployer
Time: $(date '+%Y-%m-%d %H:%M:%S')"
    
    send_slack_message "$message" "#deployments" "Deployment Bot" ":rocket:" "$color"
}

# Send alert notification
send_alert() {
    local severity=$1
    local title=$2
    local details=$3
    
    local color="warning"
    local emoji=":warning:"
    
    if [ "$severity" = "critical" ]; then
        color="danger"
        emoji=":rotating_light:"
    fi
    
    local message="*Alert: $title* $emoji
Severity: \`$severity\`
Details: $details
Server: $(hostname)
Time: $(date '+%Y-%m-%d %H:%M:%S')"
    
    send_slack_message "$message" "#alerts" "Alert Bot" "$emoji" "$color"
}

# Example usage
case "${1:-}" in
    deploy)
        send_deployment_notification "$2" "$3" "$4" "$5"
        ;;
    alert)
        send_alert "$2" "$3" "$4"
        ;;
    test)
        send_slack_message "This is a test message" "#devops" "Test Bot" ":test_tube:" "good"
        ;;
    *)
        echo "Usage: $0 {deploy|alert|test} [args]"
        ;;
esac
```

### DevOps Example: AWS CloudWatch Metrics

```bash
#!/bin/bash
# cloudwatch_metrics.sh - Send custom metrics to CloudWatch

AWS_REGION="${AWS_REGION:-us-east-1}"
NAMESPACE="${NAMESPACE:-CustomApp}"

# Send metric to CloudWatch
send_metric() {
    local metric_name=$1
    local value=$2
    local unit=${3:-Count}
    local dimensions=${4:-}
    
    local timestamp=$(date -u +"%Y-%m-%dT%H:%M:%S.000Z")
    
    local metric_data="MetricName=$metric_name,Value=$value,Unit=$unit,Timestamp=$timestamp"
    
    if [ -n "$dimensions" ]; then
        metric_data="${metric_data},Dimensions=${dimensions}"
    fi
    
    aws cloudwatch put-metric-data \
        --namespace "$NAMESPACE" \
        --metric-data "$metric_data" \
        --region "$AWS_REGION"
    
    echo "✓ Metric sent: $metric_name = $value $unit"
}

# Send application metrics
send_app_metrics() {
    # Get current metrics
    local active_users=$(curl -s http://localhost:8080/metrics/users/active | jq -r '.count')
    local response_time=$(curl -s http://localhost:8080/metrics/response_time | jq -r '.avg')
    local error_rate=$(curl -s http://localhost:8080/metrics/errors | jq -r '.rate')
    
    # Send to CloudWatch
    send_metric "ActiveUsers" "$active_users" "Count"
    send_metric "ResponseTime" "$response_time" "Milliseconds"
    send_metric "ErrorRate" "$error_rate" "Percent"
}

# Send system metrics
send_system_metrics() {
    local cpu_usage=$(top -bn1 | grep "Cpu(s)" | awk '{print $2}' | cut -d'%' -f1)
    local memory_usage=$(free | grep Mem | awk '{print ($3/$2) * 100.0}')
    local disk_usage=$(df -h / | tail -1 | awk '{print $5}' | sed 's/%//')
    
    send_metric "CPUUtilization" "$cpu_usage" "Percent"
    send_metric "MemoryUtilization" "$memory_usage" "Percent"
    send_metric "DiskUtilization" "$disk_usage" "Percent"
}

# Query CloudWatch metrics
query_metrics() {
    local metric_name=$1
    local start_time=$(date -u -d '1 hour ago' +"%Y-%m-%dT%H:%M:%S")
    local end_time=$(date -u +"%Y-%m-%dT%H:%M:%S")
    
    aws cloudwatch get-metric-statistics \
        --namespace "$NAMESPACE" \
        --metric-name "$metric_name" \
        --start-time "$start_time" \
        --end-time "$end_time" \
        --period 300 \
        --statistics Average,Maximum,Minimum \
        --region "$AWS_REGION" \
        --output json | \
        jq -r '.Datapoints | sort_by(.Timestamp) | .[] | 
            "\(.Timestamp) - Avg: \(.Average), Max: \(.Maximum), Min: \(.Minimum)"'
}

case "${1:-}" in
    app)
        send_app_metrics
        ;;
    system)
        send_system_metrics
        ;;
    query)
        query_metrics "$2"
        ;;
    *)
        echo "Usage: $0 {app|system|query} [metric_name]"
        ;;
esac
```

### Working with Different API Authentication Methods

```bash
#!/bin/bash
# api_auth_examples.sh - Different authentication methods

# 1. Basic Authentication
basic_auth() {
    local username=$1
    local password=$2
    local url=$3
    
    curl -u "$username:$password" "$url"
}

# 2. Bearer Token Authentication
bearer_token_auth() {
    local token=$1
    local url=$2
    
    curl -H "Authorization: Bearer $token" "$url"
}

# 3. API Key in Header
api_key_header() {
    local api_key=$1
    local url=$2
    
    curl -H "X-API-Key: $api_key" "$url"
}

# 4. API Key in Query Parameter
api_key_param() {
    local api_key=$1
    local url=$2
    
    curl "${url}?api_key=${api_key}"
}

# 5. OAuth 2.0 (getting access token)
oauth_get_token() {
    local client_id=$1
    local client_secret=$2
    local token_url=$3
    
    curl -X POST "$token_url" \
        -H "Content-Type: application/x-www-form-urlencoded" \
        -d "grant_type=client_credentials" \
        -d "client_id=$client_id" \
        -d "client_secret=$client_secret" | \
        jq -r '.access_token'
}

# 6. JWT Token Generation (if you have jwt tool)
generate_jwt() {
    local secret=$1
    local payload=$2
    
    echo "$payload" | jwt encode --secret="$secret" -
}

# Example: Complete API workflow with token refresh
api_workflow_example() {
    local client_id="your_client_id"
    local client_secret="your_client_secret"
    local token_url="https://api.example.com/oauth/token"
    local api_url="https://api.example.com/data"
    
    # Get access token
    echo "Getting access token..."
    local token=$(oauth_get_token "$client_id" "$client_secret" "$token_url")
    
    if [ -z "$token" ]; then
        echo "Failed to get access token"
        return 1
    fi
    
    echo "Token acquired successfully"
    
    # Make API calls with token
    local response=$(curl -s -H "Authorization: Bearer $token" "$api_url")
    
    # Check if token expired (HTTP 401)
    local http_code=$(curl -s -o /dev/null -w "%{http_code}" \
        -H "Authorization: Bearer $token" "$api_url")
    
    if [ "$http_code" -eq 401 ]; then
        echo "Token expired, refreshing..."
        token=$(oauth_get_token "$client_id" "$client_secret" "$token_url")
        response=$(curl -s -H "Authorization: Bearer $token" "$api_url")
    fi
    
    echo "$response" | jq '.'
}
```

### Parsing and Creating Complex JSON

```bash
#!/bin/bash
# json_manipulation.sh - Advanced JSON operations

# Create complex JSON structure
create_deployment_manifest() {
    local app_name=$1
    local version=$2
    local replicas=$3
    local environment=$4
    
    jq -n \
        --arg name "$app_name" \
        --arg version "$version" \
        --arg env "$environment" \
        --argjson replicas "$replicas" \
        '{
            apiVersion: "apps/v1",
            kind: "Deployment",
            metadata: {
                name: $name,
                labels: {
                    app: $name,
                    version: $version,
                    environment: $env
                }
            },
            spec: {
                replicas: $replicas,
                selector: {
                    matchLabels: {
                        app: $name
                    }
                },
                template: {
                    metadata: {
                        labels: {
                            app: $name,
                            version: $version
                        }
                    },
                    spec: {
                        containers: [{
                            name: $name,
                            image: ("registry.company.com/" + $name + ":" + $version),
                            ports: [{
                                containerPort: 8080
                            }]
                        }]
                    }
                }
            }
        }'
}

# Merge multiple JSON files
merge_json_configs() {
    local base_config=$1
    local override_config=$2
    
    jq -s '.[0] * .[1]' "$base_config" "$override_config"
}

# Transform JSON structure
transform_json() {
    local input_file=$1
    
    # Example: Convert array of objects to key-value pairs
    jq 'reduce .[] as $item ({}; .[$item.name] = $item.value)' "$input_file"
}

# Validate JSON schema (requires jq and basic validation)
validate_json() {
    local json_file=$1
    
    if jq empty "$json_file" 2>/dev/null; then
        echo "✓ Valid JSON"
        return 0
    else
        echo "✗ Invalid JSON"
        return 1
    fi
}

# Example usage
create_deployment_manifest "myapp" "v1.2.3" 3 "production" > deployment.json
echo "Deployment manifest created"
cat deployment.json | jq '.'
```

---

## 13. Process Management

### Understanding Processes

```bash
#!/bin/bash

# List all processes
ps aux

# List processes for current user
ps -u $USER

# Find specific process
ps aux | grep nginx

# Process tree
pstree

# Top processes by CPU
top -b -n 1 | head -20

# Top processes by memory
ps aux --sort=-%mem | head -10

# Get process ID by name
pgrep nginx

# Get process details
ps -p $(pgrep nginx) -o pid,ppid,cmd,%cpu,%mem

# Kill process by PID
kill 1234

# Kill process by name
pkill nginx

# Force kill
kill -9 1234
killall -9 nginx

# List open files for a process
lsof -p 1234

# Check if process is running
if pgrep nginx > /dev/null; then
    echo "Nginx is running"
else
    echo "Nginx is not running"
fi
```

### Background Jobs and Job Control

```bash
#!/bin/bash

# Run command in background
long_running_command &

# Save background job PID
BACKGROUND_PID=$!
echo "Started background job with PID: $BACKGROUND_PID"

# List background jobs
jobs

# Bring job to foreground
# fg %1

# Send job to background
# bg %1

# Wait for background job to complete
wait $BACKGROUND_PID
echo "Background job completed"

# Run multiple background jobs and wait for all
command1 &
PID1=$!
command2 &
PID2=$!
command3 &
PID3=$!

wait $PID1 $PID2 $PID3
echo "All background jobs completed"
```

### DevOps Example: Application Process Manager

```bash
#!/bin/bash
# app_manager.sh - Manage application processes

APP_NAME="myapp"
APP_JAR="/opt/${APP_NAME}/app.jar"
PID_FILE="/var/run/${APP_NAME}.pid"
LOG_FILE="/var/log/${APP_NAME}/app.log"
JVM_OPTS="-Xmx2g -Xms1g"

# Start application
start_app() {
    if is_running; then
        echo "Error: $APP_NAME is already running (PID: $(cat $PID_FILE))"
        return 1
    fi
    
    echo "Starting $APP_NAME..."
    
    # Create log directory
    mkdir -p "$(dirname $LOG_FILE)"
    
    # Start application in background
    nohup java $JVM_OPTS -jar "$APP_JAR" >> "$LOG_FILE" 2>&1 &
    
    # Save PID
    echo $! > "$PID_FILE"
    
    # Wait for application to start
    sleep 3
    
    if is_running; then
        echo "✓ $APP_NAME started successfully (PID: $(cat $PID_FILE))"
        return 0
    else
        echo "✗ Failed to start $APP_NAME"
        return 1
    fi
}

# Stop application
stop_app() {
    if ! is_running; then
        echo "$APP_NAME is not running"
        return 0
    fi
    
    local pid=$(cat $PID_FILE)
    echo "Stopping $APP_NAME (PID: $pid)..."
    
    # Try graceful shutdown first
    kill $pid
    
    # Wait up to 30 seconds for graceful shutdown
    local count=0
    while [ $count -lt 30 ] && is_running; do
        sleep 1
        ((count++))
    done
    
    # Force kill if still running
    if is_running; then
        echo "Graceful shutdown failed, force killing..."
        kill -9 $pid
        sleep 1
    fi
    
    if ! is_running; then
        rm -f "$PID_FILE"
        echo "✓ $APP_NAME stopped successfully"
        return 0
    else
        echo "✗ Failed to stop $APP_NAME"
        return 1
    fi
}

# Restart application
restart_app() {
    echo "Restarting $APP_NAME..."
    stop_app
    sleep 2
    start_app
}

# Check if application is running
is_running() {
    if [ -f "$PID_FILE" ]; then
        local pid=$(cat $PID_FILE)
        if ps -p $pid > /dev/null 2>&1; then
            return 0
        fi
    fi
    return 1
}

# Get application status
status() {
    if is_running; then
        local pid=$(cat $PID_FILE)
        local uptime=$(ps -p $pid -o etime= | tr -d ' ')
        local memory=$(ps -p $pid -o rss= | awk '{print $1/1024 " MB"}')
        local cpu=$(ps -p $pid -o %cpu= | tr -d ' ')
        
        echo "$APP_NAME is running"
        echo "  PID: $pid"
        echo "  Uptime: $uptime"
        echo "  Memory: $memory"
        echo "  CPU: $cpu%"
        
        # Check if responsive
        if curl -sf http://localhost:8080/health > /dev/null 2>&1; then
            echo "  Health: ✓ Healthy"
        else
            echo "  Health: ✗ Unhealthy"
        fi
    else
        echo "$APP_NAME is not running"
    fi
}

# Show application logs
logs() {
    local lines=${1:-50}
    
    if [ -f "$LOG_FILE" ]; then
        tail -n $lines "$LOG_FILE"
    else
        echo "Log file not found: $LOG_FILE"
    fi
}

# Follow logs in real-time
follow_logs() {
    if [ -f "$LOG_FILE" ]; then
        tail -f "$LOG_FILE"
    else
        echo "Log file not found: $LOG_FILE"
    fi
}

# Main command handling
case "${1:-}" in
    start)
        start_app
        ;;
    stop)
        stop_app
        ;;
    restart)
        restart_app
        ;;
    status)
        status
        ;;
    logs)
        logs "${2:-50}"
        ;;
    follow)
        follow_logs
        ;;
    *)
        echo "Usage: $0 {start|stop|restart|status|logs|follow}"
        exit 1
        ;;
esac
```

### DevOps Example: Process Monitoring and Auto-restart

```bash
#!/bin/bash
# process_monitor.sh - Monitor processes and restart if needed

# List of processes to monitor
declare -A PROCESSES=(
    [nginx]="/usr/sbin/nginx"
    [mysql]="/usr/sbin/mysqld"
    [redis]="/usr/bin/redis-server"
)

# Alert configuration
ALERT_EMAIL="devops@company.com"
SLACK_WEBHOOK="${SLACK_WEBHOOK:-}"

# Monitoring function
monitor_process() {
    local service_name=$1
    local process_path=$2
    
    if pgrep -f "$process_path" > /dev/null; then
        echo "✓ $service_name is running"
        return 0
    else
        echo "✗ $service_name is NOT running"
        return 1
    fi
}

# Restart service
restart_service() {
    local service_name=$1
    
    echo "Attempting to restart $service_name..."
    
    if systemctl restart "$service_name" 2>/dev/null; then
        echo "✓ $service_name restarted successfully"
        return 0
    elif service "$service_name" restart 2>/dev/null; then
        echo "✓ $service_name restarted successfully"
        return 0
    else
        echo "✗ Failed to restart $service_name"
        return 1
    fi
}

# Send alert
send_alert() {
    local service_name=$1
    local status=$2
    local message="[$(hostname)] Process Monitor Alert: $service_name is $status"
    
    # Send email
    echo "$message" | mail -s "Process Monitor Alert" "$ALERT_EMAIL"
    
    # Send Slack notification
    if [ -n "$SLACK_WEBHOOK" ]; then
        curl -X POST "$SLACK_WEBHOOK" \
            -H 'Content-Type: application/json' \
            -d "{\"text\": \"$message\"}" \
            2>/dev/null
    fi
}

# Main monitoring loop
echo "=== Process Monitor Started ==="
echo "Monitoring $(date)"
echo

RESTART_COUNT=0

for service_name in "${!PROCESSES[@]}"; do
    process_path="${PROCESSES[$service_name]}"
    
    if ! monitor_process "$service_name" "$process_path"; then
        # Process is down, attempt restart
        if restart_service "$service_name"; then
            send_alert "$service_name" "restarted after failure"
            ((RESTART_COUNT++))
            
            # Wait and verify
            sleep 5
            if monitor_process "$service_name" "$process_path"; then
                echo "✓ $service_name is now running"
            else
                send_alert "$service_name" "FAILED TO RESTART"
            fi
        else
            send_alert "$service_name" "DOWN - restart failed"
        fi
    fi
done

echo
echo "=== Monitor Summary ==="
echo "Services restarted: $RESTART_COUNT"

# Exit with error if any restarts were needed
exit $RESTART_COUNT
```

### Resource Limit Management

```bash
#!/bin/bash
# resource_limits.sh - Set and monitor resource limits

# Show current limits
show_limits() {
    echo "=== Current Resource Limits ==="
    ulimit -a
}

# Set limits for current shell
set_limits() {
    # Maximum file size (in KB)
    ulimit -f 1000000
    
    # Maximum number of open files
    ulimit -n 4096
    
    # Maximum number of processes
    ulimit -u 2048
    
    # Maximum memory size (in KB)
    ulimit -m 2097152
    
    # Maximum virtual memory (in KB)
    ulimit -v 4194304
    
    echo "Resource limits set"
}

# Check process resource usage
check_process_resources() {
    local pid=$1
    
    echo "=== Resource Usage for PID $pid ==="
    
    # Memory usage
    local mem_kb=$(ps -p $pid -o rss= | tr -d ' ')
    local mem_mb=$(echo "scale=2; $mem_kb / 1024" | bc)
    echo "Memory: ${mem_mb} MB"
    
    # CPU usage
    local cpu=$(ps -p $pid -o %cpu= | tr -d ' ')
    echo "CPU: ${cpu}%"
    
    # Number of threads
    local threads=$(ps -p $pid -o nlwp= | tr -d ' ')
    echo "Threads: $threads"
    
    # Open files
    if command -v lsof > /dev/null; then
        local open_files=$(lsof -p $pid 2>/dev/null | wc -l)
        echo "Open files: $open_files"
    fi
}

# Kill processes exceeding resource limits
kill_resource_hogs() {
    local max_cpu=${1:-80}
    local max_mem=${2:-80}
    
    echo "=== Checking for resource hogs ==="
    echo "CPU threshold: ${max_cpu}%"
    echo "Memory threshold: ${max_mem}%"
    
    # Find CPU hogs
    ps aux | awk -v max=$max_cpu '$3 > max {print $2,$3,$11}' | \
    while read pid cpu cmd; do
        echo "High CPU: PID $pid ($cpu%) - $cmd"
        # Uncomment to actually kill:
        # kill -9 $pid
    done
    
    # Find memory hogs
    ps aux | awk -v max=$max_mem '$4 > max {print $2,$4,$11}' | \
    while read pid mem cmd; do
        echo "High Memory: PID $pid ($mem%) - $cmd"
        # Uncomment to actually kill:
        # kill -9 $pid
    done
}

# Set cgroup limits (requires root)
set_cgroup_limits() {
    local cgroup_name=$1
    local memory_limit=$2  # in bytes
    local cpu_limit=$3     # CPU shares
    
    if [ "$EUID" -ne 0 ]; then
        echo "Error: This function requires root privileges"
        return 1
    fi
    
    # Create cgroup
    mkdir -p /sys/fs/cgroup/memory/$cgroup_name
    mkdir -p /sys/fs/cgroup/cpu/$cgroup_name
    
    # Set memory limit
    echo $memory_limit > /sys/fs/cgroup/memory/$cgroup_name/memory.limit_in_bytes
    
    # Set CPU limit
    echo $cpu_limit > /sys/fs/cgroup/cpu/$cgroup_name/cpu.shares
    
    echo "Cgroup $cgroup_name created with limits"
}

case "${1:-}" in
    show)
        show_limits
        ;;
    set)
        set_limits
        ;;
    check)
        check_process_resources "$2"
        ;;
    hogs)
        kill_resource_hogs "${2:-80}" "${3:-80}"
        ;;
    cgroup)
        set_cgroup_limits "$2" "$3" "$4"
        ;;
    *)
        echo "Usage: $0 {show|set|check|hogs|cgroup} [args]"
        ;;
esac
```

---

## 14. Networking and Remote Operations

### Example 1: Kubernetes Pod Restart Script

```bash
#!/bin/bash
# k8s_pod_restart.sh - Restart pods in Kubernetes

NAMESPACE="${1:-default}"
DEPLOYMENT="${2:-}"
CONTEXT="${KUBE_CONTEXT:-}"

# Set context if provided
if [ -n "$CONTEXT" ]; then
    kubectl config use-context "$CONTEXT"
fi

# Function to restart deployment
restart_deployment() {
    local namespace=$1
    local deployment=$2
    
    echo "Restarting deployment $deployment in namespace $namespace..."
    
    # Scale down to 0
    kubectl scale deployment "$deployment" --replicas=0 -n "$namespace"
    
    # Wait for pods to terminate
    echo "Waiting for pods to terminate..."
    kubectl wait --for=delete pod -l app="$deployment" -n "$namespace" --timeout=60s
    
    # Scale back up
    kubectl scale deployment "$deployment" --replicas=3 -n "$namespace"
    
    # Wait for pods to be ready
    echo "Waiting for pods to be ready..."
    kubectl wait --for=condition=ready pod -l app="$deployment" -n "$namespace" --timeout=120s
    
    echo "Deployment $deployment restarted successfully"
}

# Function to restart all deployments in namespace
restart_namespace() {
    local namespace=$1
    
    echo "Getting all deployments in namespace $namespace..."
    deployments=$(kubectl get deployments -n "$namespace" -o jsonpath='{.items[*].metadata.name}')
    
    for deployment in $deployments; do
        restart_deployment "$namespace" "$deployment"
    done
}

# Main logic
if [ -z "$DEPLOYMENT" ]; then
    echo "Restarting all deployments in namespace $NAMESPACE"
    restart_namespace "$NAMESPACE"
else
    restart_deployment "$NAMESPACE" "$DEPLOYMENT"
fi
```

### Example 2: Database Backup and Restore

```bash
#!/bin/bash
# db_backup.sh - PostgreSQL/MySQL backup with rotation

DB_TYPE="${DB_TYPE:-postgres}"  # postgres or mysql
DB_HOST="${DB_HOST:-localhost}"
DB_PORT="${DB_PORT:-5432}"
DB_NAME="${DB_NAME:-myapp}"
DB_USER="${DB_USER:-dbuser}"
DB_PASS="${DB_PASS:-}"
BACKUP_DIR="/backups/database"
RETENTION_DAYS=7
S3_BUCKET="${S3_BUCKET:-}"

# Timestamp for backup file
TIMESTAMP=$(date +%Y%m%d_%H%M%S)
BACKUP_FILE="${BACKUP_DIR}/${DB_NAME}_${TIMESTAMP}.sql.gz"

# Create backup directory
mkdir -p "$BACKUP_DIR"

echo "=== Database Backup ==="
echo "Type: $DB_TYPE"
echo "Database: $DB_NAME"
echo "Timestamp: $TIMESTAMP"
echo

# Perform backup based on database type
case $DB_TYPE in
    postgres)
        echo "Backing up PostgreSQL database..."
        export PGPASSWORD="$DB_PASS"
        pg_dump -h "$DB_HOST" -p "$DB_PORT" -U "$DB_USER" "$DB_NAME" | \
            gzip > "$BACKUP_FILE"
        unset PGPASSWORD
        ;;
    
    mysql)
        echo "Backing up MySQL database..."
        mysqldump -h "$DB_HOST" -P "$DB_PORT" -u "$DB_USER" -p"$DB_PASS" \
            "$DB_NAME" | gzip > "$BACKUP_FILE"
        ;;
    
    *)
        echo "Unsupported database type: $DB_TYPE"
        exit 1
        ;;
esac

# Check if backup was successful
if [ $? -eq 0 ] && [ -f "$BACKUP_FILE" ]; then
    BACKUP_SIZE=$(du -h "$BACKUP_FILE" | cut -f1)
    echo "✓ Backup successful: $BACKUP_FILE ($BACKUP_SIZE)"
    
    # Upload to S3 if configured
    if [ -n "$S3_BUCKET" ]; then
        echo "Uploading to S3..."
        aws s3 cp "$BACKUP_FILE" "s3://${S3_BUCKET}/database-backups/" && \
            echo "✓ Uploaded to S3"
    fi
    
    # Remove old backups
    echo "Cleaning up old backups (keeping last $RETENTION_DAYS days)..."
    find "$BACKUP_DIR" -name "${DB_NAME}_*.sql.gz" -mtime +$RETENTION_DAYS -delete
    
    # List current backups
    echo
    echo "Current backups:"
    ls -lh "$BACKUP_DIR/${DB_NAME}_"*.sql.gz 2>/dev/null | tail -5
    
else
    echo "✗ Backup failed"
    exit 1
fi
```

### Example 3: SSL Certificate Monitoring

```bash
#!/bin/bash
# ssl_monitor.sh - Monitor SSL certificate expiration

DOMAINS_FILE="${1:-domains.txt}"
ALERT_DAYS=30
ALERT_EMAIL="devops@company.com"
SLACK_WEBHOOK="${SLACK_WEBHOOK:-}"

# Function to check SSL certificate
check_ssl() {
    local domain=$1
    local port=${2:-443}
    
    # Get certificate expiry date
    local expiry_date=$(echo | \
        openssl s_client -servername "$domain" -connect "${domain}:${port}" 2>/dev/null | \
        openssl x509 -noout -dates | \
        grep "notAfter" | \
        cut -d= -f2)
    
    if [ -z "$expiry_date" ]; then
        echo "✗ $domain - Failed to retrieve certificate"
        return 1
    fi
    
    # Convert to epoch time
    local expiry_epoch=$(date -d "$expiry_date" +%s 2>/dev/null || date -j -f "%b %d %H:%M:%S %Y %Z" "$expiry_date" +%s)
    local current_epoch=$(date +%s)
    local days_until_expiry=$(( (expiry_epoch - current_epoch) / 86400 ))
    
    # Determine status
    if [ $days_until_expiry -lt 0 ]; then
        echo "✗ $domain - EXPIRED ${days_until_expiry#-} days ago"
        return 2
    elif [ $days_until_expiry -lt $ALERT_DAYS ]; then
        echo "⚠ $domain - Expires in $days_until_expiry days"
        return 1
    else
        echo "✓ $domain - Valid for $days_until_expiry days"
        return 0
    fi
}

# Function to send alert
send_alert() {
    local message=$1
    
    # Send email
    echo "$message" | mail -s "SSL Certificate Alert" "$ALERT_EMAIL"
    
    # Send Slack notification
    if [ -n "$SLACK_WEBHOOK" ]; then
        curl -X POST "$SLACK_WEBHOOK" \
            -H 'Content-Type: application/json' \
            -d "{\"text\": \"$message\"}" 2>/dev/null
    fi
}

# Main execution
echo "=== SSL Certificate Monitor ==="
echo "Checking certificates..."
echo

ALERT_MESSAGE=""
PROBLEM_COUNT=0

# Read domains from file or use default list
if [ -f "$DOMAINS_FILE" ]; then
    DOMAINS=$(cat "$DOMAINS_FILE")
else
    DOMAINS="example.com api.example.com"
fi

# Check each domain
for domain in $DOMAINS; do
    result=$(check_ssl "$domain")
    echo "$result"
    
    # Collect problems for alert
    if [[ "$result" == ✗* ]] || [[ "$result" == ⚠* ]]; then
        ALERT_MESSAGE="${ALERT_MESSAGE}
${result}"
        ((PROBLEM_COUNT++))
    fi
done

echo
echo "=== Summary ==="
echo "Total domains checked: $(echo "$DOMAINS" | wc -w)"
echo "Domains with issues: $PROBLEM_COUNT"

# Send alert if problems found
if [ $PROBLEM_COUNT -gt 0 ]; then
    echo "Sending alert..."
    send_alert "SSL Certificate Issues Detected:${ALERT_MESSAGE}"
fi
```

### Example 4: Jenkins Pipeline Helper Script

```bash
#!/bin/bash
# jenkins_pipeline.sh - Reusable Jenkins pipeline script

set -euo pipefail

# Configuration from Jenkins environment
BUILD_NUMBER="${BUILD_NUMBER:-0}"
GIT_BRANCH="${GIT_BRANCH:-main}"
GIT_COMMIT="${GIT_COMMIT:-unknown}"
WORKSPACE="${WORKSPACE:-$(pwd)}"

# Application configuration
APP_NAME="myapp"
DOCKER_REGISTRY="registry.company.com"
DOCKER_IMAGE="${DOCKER_REGISTRY}/${APP_NAME}"
K8S_NAMESPACE="${K8S_NAMESPACE:-default}"

# Logging
log() {
    echo "[$(date '+%Y-%m-%d %H:%M:%S')] $*"
}

# Stage 1: Checkout and Setup
stage_checkout() {
    log "STAGE: Checkout and Setup"
    cd "$WORKSPACE"
    
    # Clean workspace
    git clean -fdx
    
    # Display build info
    log "Build Number: $BUILD_NUMBER"
    log "Git Branch: $GIT_BRANCH"
    log "Git Commit: $GIT_COMMIT"
}

# Stage 2: Build
stage_build() {
    log "STAGE: Build"
    
    # Maven build
    mvn clean package -DskipTests -B
    
    # Check if artifact was created
    if [ ! -f "target/${APP_NAME}.jar" ]; then
        log "ERROR: Build artifact not found"
        exit 1
    fi
    
    log "Build successful"
}

# Stage 3: Unit Tests
stage_test() {
    log "STAGE: Unit Tests"
    
    mvn test -B
    
    # Publish test results (if Jenkins plugin available)
    if [ -d "target/surefire-reports" ]; then
        log "Test reports available in target/surefire-reports"
    fi
}

# Stage 4: Code Quality
stage_quality() {
    log "STAGE: Code Quality"
    
    # SonarQube analysis (if configured)
    if [ -n "${SONAR_HOST:-}" ]; then
        mvn sonar:sonar \
            -Dsonar.host.url="$SONAR_HOST" \
            -Dsonar.login="$SONAR_TOKEN"
    fi
    
    # Additional quality checks
    # shellcheck, hadolint, etc.
}

# Stage 5: Docker Build
stage_docker_build() {
    log "STAGE: Docker Build"
    
    local tag="${DOCKER_IMAGE}:${BUILD_NUMBER}"
    local latest="${DOCKER_IMAGE}:latest"
    
    # Build Docker image
    docker build \
        --build-arg BUILD_NUMBER="$BUILD_NUMBER" \
        --build-arg GIT_COMMIT="$GIT_COMMIT" \
        -t "$tag" \
        -t "$latest" \
        .
    
    log "Docker image built: $tag"
}

# Stage 6: Docker Push
stage_docker_push() {
    log "STAGE: Docker Push"
    
    local tag="${DOCKER_IMAGE}:${BUILD_NUMBER}"
    
    # Login to registry
    echo "$DOCKER_PASSWORD" | docker login "$DOCKER_REGISTRY" -u "$DOCKER_USERNAME" --password-stdin
    
    # Push images
    docker push "$tag"
    docker push "${DOCKER_IMAGE}:latest"
    
    log "Docker images pushed to registry"
}

# Stage 7: Deploy to Kubernetes
stage_deploy() {
    log "STAGE: Deploy to Kubernetes"
    
    local image="${DOCKER_IMAGE}:${BUILD_NUMBER}"
    
    # Update Kubernetes deployment
    kubectl set image deployment/${APP_NAME} \
        ${APP_NAME}="$image" \
        -n "$K8S_NAMESPACE"
    
    # Wait for rollout
    kubectl rollout status deployment/${APP_NAME} \
        -n "$K8S_NAMESPACE" \
        --timeout=5m
    
    log "Deployment successful"
}

# Stage 8: Smoke Tests
stage_smoke_tests() {
    log "STAGE: Smoke Tests"
    
    # Get service endpoint
    local service_url="http://${APP_NAME}.${K8S_NAMESPACE}.svc.cluster.local"
    
    # Health check
    for i in {1..30}; do
        if curl -sf "${service_url}/health" > /dev/null; then
            log "✓ Health check passed"
            return 0
        fi
        log "Waiting for service to be ready (attempt $i/30)..."
        sleep 2
    done
    
    log "ERROR: Smoke tests failed"
    return 1
}

# Main pipeline execution
main() {
    log "=== Starting CI/CD Pipeline ==="
    
    stage_checkout
    stage_build
    stage_test
    stage_quality
    stage_docker_build
    
    # Only push and deploy on main branch
    if [ "$GIT_BRANCH" = "main" ] || [ "$GIT_BRANCH" = "origin/main" ]; then
        stage_docker_push
        stage_deploy
        stage_smoke_tests
    else
        log "Skipping push and deploy for branch: $GIT_BRANCH"
    fi
    
    log "=== Pipeline Complete ==="
}

# Execute pipeline
main "$@"
```

### Example 5: Infrastructure Cost Report

```bash
#!/bin/bash
# aws_cost_report.sh - Generate AWS cost report

AWS_PROFILE="${AWS_PROFILE:-default}"
START_DATE=$(date -d "1 month ago" +%Y-%m-%d)
END_DATE=$(date +%Y-%m-%d)
REPORT_FILE="aws_cost_report_$(date +%Y%m%d).html"

# Get cost data from AWS Cost Explorer
get_cost_data() {
    aws ce get-cost-and-usage \
        --profile "$AWS_PROFILE" \
        --time-period Start="$START_DATE",End="$END_DATE" \
        --granularity MONTHLY \
        --metrics "UnblendedCost" \
        --group-by Type=DIMENSION,Key=SERVICE \
        --output json
}

# Generate HTML report
generate_report() {
    local data=$1
    
    cat > "$REPORT_FILE" << 'EOF'
<!DOCTYPE html>
<html>
<head>
    <title>AWS Cost Report</title>
    <style>
        body { font-family: Arial, sans-serif; margin: 20px; }
        h1 { color: #232F3E; }
        table { border-collapse: collapse; width: 100%; }
        th, td { border: 1px solid #ddd; padding: 12px; text-align: left; }
        th { background-color: #FF9900; color: white; }
        tr:nth-child(even) { background-color: #f2f2f2; }
        .total { font-weight: bold; background-color: #232F3E; color: white; }
    </style>
</head>
<body>
    <h1>AWS Cost Report</h1>
    <p>Period: <START_DATE> to <END_DATE></p>
    <table>
        <tr>
            <th>Service</th>
            <th>Cost (USD)</th>
        </tr>
EOF

    # Parse JSON and add rows
    echo "$data" | jq -r '.ResultsByTime[0].Groups[] | 
        "<tr><td>" + .Keys[0] + "</td><td>$" + (.Metrics.UnblendedCost.Amount | tonumber | round | tostring) + "</td></tr>"' >> "$REPORT_FILE"
    
    # Calculate total
    local total=$(echo "$data" | jq '[.ResultsByTime[0].Groups[].Metrics.UnblendedCost.Amount | tonumber] | add | round')
    
    cat >> "$REPORT_FILE" << EOF
        <tr class="total">
            <td>Total</td>
            <td>\$$total</td>
        </tr>
    </table>
</body>
</html>
EOF

    # Replace placeholders
    sed -i "s/<START_DATE>/$START_DATE/g" "$REPORT_FILE"
    sed -i "s/<END_DATE>/$END_DATE/g" "$REPORT_FILE"
}

# Main execution
echo "Fetching AWS cost data..."
COST_DATA=$(get_cost_data)

echo "Generating report..."
generate_report "$COST_DATA"

echo "Report generated: $REPORT_FILE"

# Send report via email
if command -v mail > /dev/null; then
    echo "Sending report via email..."
    mail -s "AWS Cost Report" \
         -a "$REPORT_FILE" \
         finance@company.com < /dev/null
fi
```

---

## 13. Best Practices

### 1. Script Header and Documentation

```bash
#!/usr/bin/env bash
#
# Script Name: deploy_application.sh
# Description: Deploy application to production environment
# Author: DevOps Team
# Created: 2024-01-15
# Modified: 2024-03-20
# Version: 2.1.0
#
# Usage: ./deploy_application.sh [environment] [version]
# Example: ./deploy_application.sh production v1.2.3
#
# Requirements:
#   - kubectl installed and configured
#   - AWS CLI configured
#   - Docker installed
#
# Exit Codes:
#   0 - Success
#   1 - General error
#   2 - Missing dependencies
#   3 - Deployment failed
#   4 - Verification failed

set -euo pipefail

# Your script code here
```

### 2. Use Meaningful Variable Names

```bash
# Bad
a=10
x=$(hostname)
f="/tmp/file.txt"

# Good
MAX_RETRIES=10
CURRENT_HOSTNAME=$(hostname)
TEMP_LOG_FILE="/tmp/application.log"
```

### 3. Quote Variables

```bash
# Bad - can break with spaces or special characters
file_path=/path/to/my file.txt
rm $file_path  # This will try to delete multiple files!

# Good
file_path="/path/to/my file.txt"
rm "$file_path"  # Correctly handles spaces

# Always quote
echo "$USER"
cd "$HOME"
for file in "$@"; do
    echo "$file"
done
```

### 4. Use Functions for Reusability

```bash
# Bad - repeated code
echo "Starting task 1..."
date
# ... task 1 code ...
echo "Task 1 complete"
date

echo "Starting task 2..."
date
# ... task 2 code ...
echo "Task 2 complete"
date

# Good - reusable function
run_task() {
    local task_name=$1
    echo "Starting $task_name..."
    date
    
    # Execute task
    "$@"  # Run remaining arguments as command
    
    echo "$task_name complete"
    date
}

run_task "Task 1" task1_function
run_task "Task 2" task2_function
```

### 5. Check for Required Dependencies

```bash
#!/bin/bash

# Check for required commands
REQUIRED_COMMANDS=("docker" "kubectl" "aws" "jq")

for cmd in "${REQUIRED_COMMANDS[@]}"; do
    if ! command -v "$cmd" &> /dev/null; then
        echo "ERROR: Required command '$cmd' not found"
        echo "Please install $cmd and try again"
        exit 2
    fi
done

echo "All dependencies satisfied"
```

### 6. Validate Input

```bash
#!/bin/bash

# Function to validate input
validate_environment() {
    local env=$1
    local valid_envs=("dev" "staging" "production")
    
    for valid_env in "${valid_envs[@]}"; do
        if [ "$env" = "$valid_env" ]; then
            return 0
        fi
    done
    
    return 1
}

# Get environment from argument
ENVIRONMENT=${1:-}

if [ -z "$ENVIRONMENT" ]; then
    echo "ERROR: Environment not specified"
    echo "Usage: $0 {dev|staging|production}"
    exit 1
fi

if ! validate_environment "$ENVIRONMENT"; then
    echo "ERROR: Invalid environment '$ENVIRONMENT'"
    echo "Valid environments: dev, staging, production"
    exit 1
fi

echo "Deploying to $ENVIRONMENT..."
```

### 7. Use Readonly for Constants

```bash
#!/bin/bash

# Define constants
readonly API_ENDPOINT="https://api.company.com"
readonly MAX_RETRIES=3
readonly TIMEOUT_SECONDS=30

# These cannot be changed
# API_ENDPOINT="http://different.com"  # This would cause an error
```

### 8. Implement Proper Logging

```bash
#!/bin/bash

# Logging configuration
readonly LOG_FILE="/var/log/myapp/script.log"
readonly LOG_LEVEL="${LOG_LEVEL:-INFO}"  # DEBUG, INFO, WARN, ERROR

# Ensure log directory exists
mkdir -p "$(dirname "$LOG_FILE")"

# Logging functions
log() {
    local level=$1
    shift
    local message="$@"
    local timestamp=$(date '+%Y-%m-%d %H:%M:%S')
    
    # Log to file
    echo "[$timestamp] [$level] $message" >> "$LOG_FILE"
    
    # Also output to console for certain levels
    case $level in
        ERROR)
            echo "[$timestamp] [$level] $message" >&2
            ;;
        WARN|INFO)
            echo "[$timestamp] [$level] $message"
            ;;
    esac
}

log_debug() {
    [ "$LOG_LEVEL" = "DEBUG" ] && log "DEBUG" "$@"
}

log_info() {
    log "INFO" "$@"
}

log_warn() {
    log "WARN" "$@"
}

log_error() {
    log "ERROR" "$@"
}

# Usage
log_info "Script started"
log_debug "Debug information"
log_warn "Warning message"
log_error "Error occurred"
```

### 9. Use Shellcheck

```bash
# Install shellcheck
# Ubuntu/Debian: apt-get install shellcheck
# macOS: brew install shellcheck
# RHEL/CentOS: yum install shellcheck

# Check your script
shellcheck myscript.sh

# Integrate into CI/CD
find . -name "*.sh" -exec shellcheck {} \;
```

### 10. Template: Production-Ready Script

```bash
#!/usr/bin/env bash
#
# Script Name: production_template.sh
# Description: Production-ready script template with best practices
# Version: 1.0.0

set -euo pipefail
IFS=$'\n\t'

# ============================================================================
# CONFIGURATION
# ============================================================================

readonly SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
readonly SCRIPT_NAME="$(basename "${BASH_SOURCE[0]}")"
readonly LOG_FILE="${LOG_FILE:-/var/log/${SCRIPT_NAME%.sh}.log}"

# ============================================================================
# FUNCTIONS
# ============================================================================

# Logging
log() {
    local level=$1
    shift
    echo "[$(date '+%Y-%m-%d %H:%M:%S')] [$level] $*" | tee -a "$LOG_FILE"
}

log_info()  { log "INFO"  "$@"; }
log_warn()  { log "WARN"  "$@"; }
log_error() { log "ERROR" "$@" >&2; }

# Error handling
error_exit() {
    log_error "$1"
    exit "${2:-1}"
}

# Cleanup function
cleanup() {
    local exit_code=$?
    
    if [ $exit_code -ne 0 ]; then
        log_error "Script failed with exit code $exit_code"
    else
        log_info "Script completed successfully"
    fi
    
    # Perform cleanup tasks
    rm -f /tmp/${SCRIPT_NAME}_*.tmp
}

# Dependency checking
check_dependencies() {
    local required_commands=("$@")
    
    for cmd in "${required_commands[@]}"; do
        if ! command -v "$cmd" &> /dev/null; then
            error_exit "Required command not found: $cmd" 2
        fi
    done
}

# Input validation
validate_input() {
    # Add your validation logic here
    return 0
}

# ============================================================================
# MAIN LOGIC
# ============================================================================

main() {
    log_info "Starting $SCRIPT_NAME"
    
    # Check dependencies
    check_dependencies "curl" "jq" "docker"
    
    # Validate input
    validate_input || error_exit "Invalid input" 1
    
    # Your main logic here
    log_info "Executing main logic..."
    
    # Example: Your actual work
    # do_something || error_exit "Failed to do something" 3
    
    log_info "Main logic completed"
}

# ============================================================================
# SCRIPT EXECUTION
# ============================================================================

# Set trap for cleanup
trap cleanup EXIT

# Execute main function
main "$@"
```

---

## 12. Working with APIs and JSON

[Content is too long to paste here - I'll create a separate file with all the new sections]

---

## Conclusion

This comprehensive guide covers the essential aspects of Bash scripting for DevOps engineers. Remember these key takeaways:

1. **Always use proper error handling** with `set -euo pipefail`
2. **Quote your variables** to prevent word splitting issues
3. **Implement logging** for troubleshooting and auditing
4. **Use functions** for code reusability and maintainability
5. **Validate inputs** to prevent unexpected behavior
6. **Test your scripts** in non-production environments first
7. **Document your code** with comments and headers
8. **Use version control** (Git) for all your scripts
9. **Follow security best practices** - never hardcode credentials
10. **Use ShellCheck** to catch common mistakes

Bash scripting is a fundamental skill for DevOps engineers. Master these concepts, practice regularly, and you'll be able to automate complex infrastructure tasks efficiently and reliably.

## Additional Resources

- [Bash Manual](https://www.gnu.org/software/bash/manual/)
- [ShellCheck](https://www.shellcheck.net/) - Script analysis tool
- [Bash Best Practices](https://bertvv.github.io/cheat-sheets/Bash.html)
- [Google Shell Style Guide](https://google.github.io/styleguide/shellguide.html)
- [Advanced Bash-Scripting Guide](https://tldp.org/LDP/abs/html/)
