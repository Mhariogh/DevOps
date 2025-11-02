# Docker Command Quick Reference
## Student Cheat Sheet

---

## Container Lifecycle

### Create & Run
```bash
docker run [OPTIONS] IMAGE [COMMAND]
```

**Common Options:**
- `-d` - Run in background (detached mode)
- `-p HOST:CONTAINER` - Map ports (e.g., `-p 3000:80`)
- `--name NAME` - Give container a specific name
- `-e VAR=value` - Set environment variable
- `-v VOLUME:PATH` - Mount volume
- `--network NETWORK` - Connect to network
- `-it` - Interactive mode with terminal

**Examples:**
```bash
# Simple run
docker run nginx

# Run in background with port mapping
docker run -d -p 8080:80 nginx

# Run with name and environment variable
docker run -d --name my-app -e PORT=3000 my-image

# Run with volume and network
docker run -d \
  --name app \
  -v mydata:/data \
  --network my-net \
  my-image
```

---

### Manage Running Containers

```bash
# List running containers
docker ps

# List all containers (including stopped)
docker ps -a

# Stop a container
docker stop CONTAINER

# Start a stopped container
docker start CONTAINER

# Restart a container
docker restart CONTAINER

# Remove a container (must be stopped first)
docker rm CONTAINER

# Force remove a running container
docker rm -f CONTAINER

# Remove all stopped containers
docker container prune
```

---

### Inspect & Debug

```bash
# View container logs
docker logs CONTAINER

# Follow logs in real-time
docker logs -f CONTAINER

# View last 100 lines
docker logs --tail 100 CONTAINER

# Execute command in running container
docker exec CONTAINER COMMAND

# Get interactive shell in container
docker exec -it CONTAINER bash
# or if bash not available:
docker exec -it CONTAINER sh

# View container details (JSON)
docker inspect CONTAINER

# View container's port mappings
docker port CONTAINER

# View resource usage statistics
docker stats CONTAINER
```

---

## Images

```bash
# List all images
docker images

# Pull an image from registry
docker pull IMAGE:TAG

# Remove an image
docker rmi IMAGE

# Remove unused images
docker image prune

# Build image from Dockerfile
docker build -t NAME:TAG .

# Tag an image
docker tag SOURCE TARGET
```

---

## Volumes

```bash
# Create a volume
docker volume create VOLUME_NAME

# List volumes
docker volume ls

# Inspect a volume
docker volume inspect VOLUME_NAME

# Remove a volume
docker volume rm VOLUME_NAME

# Remove all unused volumes
docker volume prune
```

**Using Volumes:**
```bash
# Named volume
docker run -v volume_name:/path/in/container IMAGE

# Bind mount (specific host directory)
docker run -v /host/path:/container/path IMAGE

# Example with MySQL
docker run -d \
  -v mysql_data:/var/lib/mysql \
  mysql:8.0
```

---

## Networks

```bash
# Create a network
docker network create NETWORK_NAME

# List networks
docker network ls

# Inspect a network
docker network inspect NETWORK_NAME

# Connect container to network
docker network connect NETWORK CONTAINER

# Disconnect container from network
docker network disconnect NETWORK CONTAINER

# Remove a network
docker network rm NETWORK_NAME
```

**Using Networks:**
```bash
# Run container on specific network
docker run -d --network my-net nginx

# Run with network alias (like DNS name)
docker run -d \
  --network my-net \
  --network-alias db \
  mysql:8.0
```

---

## Port Mapping

**Format:** `-p HOST_PORT:CONTAINER_PORT`

```bash
# Map port 8080 on host to port 80 in container
docker run -d -p 8080:80 nginx
# Access via: localhost:8080

# Map port 3000 to 3000 (same on both)
docker run -d -p 3000:3000 my-app
# Access via: localhost:3000

# Map random host port to container port
docker run -d -p 80 nginx
# Docker assigns a random port on host
```

**Remember:** 
- First number = port on YOUR computer (host)
- Second number = port INSIDE container
- You access using the FIRST number

---

## Environment Variables

```bash
# Single variable
docker run -e VAR_NAME=value IMAGE

# Multiple variables
docker run \
  -e DB_HOST=localhost \
  -e DB_PORT=3306 \
  -e DB_NAME=mydb \
  IMAGE

# Common uses:
docker run -d \
  -e MYSQL_ROOT_PASSWORD=secret \
  mysql:8.0
```

---

## Common Patterns

### Web Application + Database

```bash
# 1. Create network
docker network create app-net

# 2. Run database
docker run -d \
  --name db \
  --network app-net \
  --network-alias database \
  -v db-data:/var/lib/mysql \
  -e MYSQL_ROOT_PASSWORD=secret \
  -e MYSQL_DATABASE=myapp \
  mysql:8.0

# 3. Run application
docker run -d \
  --name app \
  --network app-net \
  -p 3000:3000 \
  -e DB_HOST=database \
  -e DB_PASSWORD=secret \
  my-app-image
```

---

### Persist Data with Volumes

```bash
# Create volume first (optional, docker creates automatically)
docker volume create my-data

# Use volume in container
docker run -d \
  --name app \
  -v my-data:/app/data \
  my-image

# Data persists even if you:
docker stop app
docker rm app

# New container can access same data:
docker run -d \
  --name app2 \
  -v my-data:/app/data \
  my-image
```

---

## Troubleshooting Guide

### Container won't start / keeps restarting
```bash
# Check logs for errors
docker logs CONTAINER

# Check container details
docker inspect CONTAINER

# Try running in foreground to see output
docker run IMAGE  # (without -d)
```

### Can't access application on localhost
```bash
# Check if container is running
docker ps

# Check port mappings
docker port CONTAINER

# Check logs for application errors
docker logs CONTAINER

# Verify port mapping is correct
# -p 3000:3000 means access at localhost:3000
```

### Container can't connect to database
```bash
# Check both containers are on same network
docker inspect CONTAINER | grep NetworkMode

# Verify network alias
docker inspect CONTAINER | grep Alias

# Check database is running
docker ps

# Check database logs
docker logs DB_CONTAINER
```

### Data disappeared after restart
```bash
# Check if you used a volume
docker inspect CONTAINER | grep Mounts

# If no volume, data is lost!
# Solution: Always use volumes for data:
docker run -d -v mydata:/path/to/data IMAGE
```

---

## Quick Troubleshooting Commands

```bash
# Is it running?
docker ps | grep CONTAINER_NAME

# What went wrong?
docker logs CONTAINER

# What's the full config?
docker inspect CONTAINER

# What ports?
docker port CONTAINER

# Get inside to investigate:
docker exec -it CONTAINER sh
```

---

## Command Comparison Chart

| Task | Command |
|------|---------|
| Create & start container | `docker run` |
| Start stopped container | `docker start` |
| Stop running container | `docker stop` |
| Delete container | `docker rm` |
| See running containers | `docker ps` |
| See all containers | `docker ps -a` |
| See container output | `docker logs` |
| Run command in container | `docker exec` |
| Get into container | `docker exec -it CONTAINER sh` |

---

## Port Mapping Quick Reference

```bash
# Pattern: -p HOST:CONTAINER

localhost:3000  →  -p 3000:3000  →  container:3000
localhost:8080  →  -p 8080:80    →  container:80
localhost:3306  →  -p 3306:3306  →  container:3306

# You type in browser: localhost:HOST_PORT
# Traffic goes to: container:CONTAINER_PORT
```

---

## Volume Quick Reference

```bash
# Named volume (Docker manages location)
-v volume_name:/path/in/container

# Bind mount (you specify location)
-v /your/computer/path:/path/in/container

# Common volume paths:
MySQL:       /var/lib/mysql
PostgreSQL:  /var/lib/postgresql/data
MongoDB:     /data/db
```

---

## Network Quick Reference

```bash
# Create network
docker network create my-net

# Run containers on same network
docker run --network my-net --name app1 IMAGE1
docker run --network my-net --name app2 IMAGE2

# Containers can reach each other using names:
# app1 can ping app2
# app2 can ping app1
```

---

## Common Flags Explained

| Flag | What it does | Example |
|------|-------------|---------|
| `-d` | Run in background | `docker run -d nginx` |
| `-p` | Map ports | `docker run -p 3000:80 nginx` |
| `--name` | Name the container | `docker run --name web nginx` |
| `-e` | Set environment variable | `docker run -e PORT=3000 app` |
| `-v` | Mount volume | `docker run -v data:/app app` |
| `--network` | Connect to network | `docker run --network net app` |
| `-it` | Interactive with terminal | `docker run -it ubuntu bash` |
| `--rm` | Delete after stop | `docker run --rm nginx` |

---

## Remember These Rules!

✅ **DO:**
- Use `-d` for servers and long-running services
- Use named volumes for data persistence
- Put related containers on same network
- Use `--name` to give containers readable names
- Check logs when something goes wrong

❌ **DON'T:**
- Forget to use volumes for database containers
- Try to use same port for multiple containers
- Try to use same name for multiple containers
- Forget that stopped containers still exist
- Store important data without volumes

---

## Getting Help

```bash
# Get help for any command
docker COMMAND --help

# Examples:
docker run --help
docker network --help
docker volume --help
```

---

## One-Line Quick Actions

```bash
# Clean up everything (BE CAREFUL!)
docker system prune -a

# Stop all running containers
docker stop $(docker ps -q)

# Remove all containers
docker rm $(docker ps -aq)

# Remove all volumes
docker volume prune

# Remove all networks
docker network prune

# See disk usage
docker system df
```

---

**Pro Tip:** When in doubt:
1. Check if it's running: `docker ps`
2. Check the logs: `docker logs CONTAINER`
3. Check the config: `docker inspect CONTAINER`

---

**Common Error Messages & Fixes:**

❌ "port is already allocated"
→ Another container is using that port, use different port

❌ "container name already in use"  
→ A container with that name exists, use `docker rm NAME` or different name

❌ "No such container"
→ Check the name with `docker ps -a`

❌ "Cannot connect to database"
→ Check both containers are on same network

---

**Remember:** 
- Images are like "recipes" (docker pull)
- Containers are like "cakes made from recipes" (docker run)
- Volumes are like "tupperware for storing leftovers" (survives even if you throw away the cake!)
- Networks are like "phone lines" (containers can call each other)
