# Dockerfile Quick Reference Cheat Sheet
## Student Guide

---

## Basic Dockerfile Structure

```dockerfile
FROM <image>:<tag>
WORKDIR <directory>
COPY <source> <destination>
RUN <command>
EXPOSE <port>
CMD ["executable", "param"]
```

---

## Essential Instructions

### FROM - Base Image (Required, Must be First)

```dockerfile
FROM node:18
FROM python:3.11
FROM nginx:alpine
FROM ubuntu:22.04
```

**Tips:**
- Always use specific versions (not `latest`)
- Use `-alpine` or `-slim` for smaller images
- Must be the first instruction

---

### WORKDIR - Set Working Directory

```dockerfile
WORKDIR /app
```

**What it does:**
- Sets the directory for all following commands
- Creates the directory if it doesn't exist
- Like `cd` in terminal

**Example:**
```dockerfile
WORKDIR /app
COPY . .        # Copies to /app
RUN npm install # Runs in /app
```

---

### COPY - Copy Files from Host to Container

```dockerfile
# Copy single file
COPY app.py /app/

# Copy to current directory (set by WORKDIR)
COPY app.py .

# Copy everything
COPY . .

# Copy multiple files
COPY file1.txt file2.txt /app/
```

**Pattern for Dependencies:**
```dockerfile
# Copy dependency file first
COPY package.json .
RUN npm install

# Then copy source code
COPY . .
```

**Why?** Layer caching! If only source changes, npm install is cached.

---

### ADD - Like COPY but with Extra Features

```dockerfile
# Copy and auto-extract tar file
ADD archive.tar.gz /app/
```

**Rule:** Use COPY unless you need ADD's special features.

---

### RUN - Execute Commands (Build Time)

```dockerfile
# Install packages
RUN apt-get update && apt-get install -y curl

# Install Node dependencies
RUN npm install

# Install Python dependencies
RUN pip install -r requirements.txt
```

**Best Practice - Combine Commands:**
```dockerfile
# BAD - Multiple layers
RUN apt-get update
RUN apt-get install -y curl
RUN apt-get install -y git

# GOOD - One layer
RUN apt-get update && apt-get install -y \
    curl \
    git \
    && rm -rf /var/lib/apt/lists/*
```

**Why?**
- Fewer layers = smaller image
- Clean up in same layer (cache removal actually works)

---

### CMD - Default Command (Run Time)

```dockerfile
# Array format (recommended)
CMD ["python", "app.py"]
CMD ["node", "server.js"]
CMD ["npm", "start"]

# Shell format (avoid)
CMD python app.py
```

**Rules:**
- Only ONE CMD per Dockerfile (last one wins)
- Runs when container starts
- Can be overridden from command line
- Use array format (exec form)

---

### ENTRYPOINT - Container Executable

```dockerfile
ENTRYPOINT ["python"]
CMD ["app.py"]
```

**When to use:**
- When container should always run same executable
- Use with CMD for default arguments

**Example:**
```dockerfile
ENTRYPOINT ["curl"]
CMD ["--help"]
```
- Default: `docker run my-curl` → runs `curl --help`
- Override: `docker run my-curl https://example.com` → runs `curl https://example.com`

---

### EXPOSE - Document Ports

```dockerfile
EXPOSE 3000
EXPOSE 80 443
```

**Important:** This does NOT publish ports! Use `-p` when running:
```bash
docker run -p 8080:3000 my-image
```

---

### ENV - Environment Variables

```dockerfile
ENV NODE_ENV=production
ENV PORT=3000
ENV DB_HOST=localhost

# Or multiple in one line
ENV NODE_ENV=production \
    PORT=3000 \
    DB_HOST=localhost
```

**Override at runtime:**
```bash
docker run -e PORT=8080 my-image
```

---

### VOLUME - Persistent Storage

```dockerfile
VOLUME /app/data
```

**Usually better to specify volume at runtime:**
```bash
docker run -v mydata:/app/data my-image
```

---

### USER - Run as Non-Root (Security)

```dockerfile
# Create user and switch to it
RUN adduser --disabled-password myuser
USER myuser
```

**Important:** Commands after USER run as that user.

---

## Common Patterns

### Pattern 1: Node.js Application

```dockerfile
FROM node:18-alpine
WORKDIR /app

# Copy dependency files
COPY package*.json ./

# Install dependencies
RUN npm ci --only=production

# Copy source code
COPY . .

# Expose port
EXPOSE 3000

# Start app
CMD ["npm", "start"]
```

---

### Pattern 2: Python Application

```dockerfile
FROM python:3.11-slim
WORKDIR /app

# Copy requirements first
COPY requirements.txt .

# Install dependencies
RUN pip install --no-cache-dir -r requirements.txt

# Copy application
COPY . .

# Expose port
EXPOSE 5000

# Run app
CMD ["python", "app.py"]
```

---

### Pattern 3: Static Website (Nginx)

```dockerfile
FROM nginx:alpine

# Copy static files
COPY . /usr/share/nginx/html/

# Nginx automatically exposes port 80
# No CMD needed - base image has it
```

---

### Pattern 4: Multi-Stage Build

```dockerfile
# Stage 1: Build
FROM node:18 AS builder
WORKDIR /app
COPY package*.json ./
RUN npm install
COPY . .
RUN npm run build

# Stage 2: Production
FROM node:18-alpine
WORKDIR /app
COPY package*.json ./
RUN npm ci --only=production
COPY --from=builder /app/dist ./dist
CMD ["node", "dist/server.js"]
```

**Why?** Final image only contains what's needed to run, not build tools.

---

## Building Images

### Basic Build

```bash
# Build from current directory
docker build -t my-app .

# Build with specific tag
docker build -t my-app:v1.0 .

# Build from different directory
docker build -t my-app -f /path/to/Dockerfile /path/to/context
```

---

### Build Options

```bash
# No cache (force rebuild)
docker build --no-cache -t my-app .

# Show all build output
docker build --progress=plain -t my-app .

# Build with build argument
docker build --build-arg VERSION=1.0 -t my-app .
```

---

## .dockerignore File

Create `.dockerignore` in same directory as Dockerfile:

```
# Dependencies
node_modules/
__pycache__/

# Git
.git/
.gitignore

# Environment files
.env
.env.local

# Documentation
README.md
docs/

# IDE
.vscode/
.idea/

# OS files
.DS_Store
Thumbs.db

# Tests
tests/
*.test.js
coverage/
```

**Why?** Faster builds, smaller images, better security.

---

## Optimization Tips

### 1. Order Instructions by Change Frequency

```dockerfile
# GOOD - Rarely changing stuff first
FROM node:18
WORKDIR /app
COPY package*.json ./      # Changes rarely
RUN npm install            # Cached if package.json unchanged
COPY . .                   # Changes often, but doesn't break cache above
```

---

### 2. Combine RUN Commands

```dockerfile
# BAD
RUN apt-get update
RUN apt-get install -y curl
RUN apt-get install -y git

# GOOD
RUN apt-get update && apt-get install -y \
    curl \
    git \
    && rm -rf /var/lib/apt/lists/*
```

---

### 3. Use Smaller Base Images

```dockerfile
# Large (~900MB)
FROM node:18

# Medium (~300MB)
FROM node:18-slim

# Small (~100MB)
FROM node:18-alpine
```

---

### 4. Clean Up in Same Layer

```dockerfile
# This DOESN'T reduce size (separate layer)
RUN apt-get update && apt-get install -y curl
RUN rm -rf /var/lib/apt/lists/*

# This DOES reduce size (same layer)
RUN apt-get update && apt-get install -y curl \
    && rm -rf /var/lib/apt/lists/*
```

---

### 5. Use Multi-Stage Builds

```dockerfile
# Build stage - can be large
FROM node:18 AS builder
WORKDIR /app
COPY . .
RUN npm install && npm run build

# Runtime stage - small
FROM node:18-alpine
COPY --from=builder /app/dist ./dist
CMD ["node", "dist/server.js"]
```

---

## Common Mistakes & Solutions

### Mistake 1: Wrong Instruction Order

**Problem:**
```dockerfile
FROM node:18
WORKDIR /app
RUN npm install        # Nothing to install yet!
COPY package.json .
```

**Solution:**
```dockerfile
FROM node:18
WORKDIR /app
COPY package.json .
RUN npm install
```

---

### Mistake 2: Using RUN for Startup Command

**Problem:**
```dockerfile
RUN python app.py      # Tries to run during build!
```

**Solution:**
```dockerfile
CMD ["python", "app.py"]  # Runs when container starts
```

---

### Mistake 3: Copying Everything First

**Problem:**
```dockerfile
COPY . .               # Any change breaks cache
RUN npm install
```

**Solution:**
```dockerfile
COPY package*.json ./  # Only dependency changes break cache
RUN npm install
COPY . .
```

---

### Mistake 4: Not Cleaning Up

**Problem:**
```dockerfile
RUN apt-get update && apt-get install -y curl
# Cache files remain in image
```

**Solution:**
```dockerfile
RUN apt-get update && apt-get install -y curl \
    && rm -rf /var/lib/apt/lists/*
```

---

### Mistake 5: Using Latest Tag

**Problem:**
```dockerfile
FROM node:latest       # Unpredictable, can break
```

**Solution:**
```dockerfile
FROM node:18.17        # Specific, reproducible
```

---

## Quick Command Reference

| Task | Command |
|------|---------|
| Build image | `docker build -t name .` |
| Build with tag | `docker build -t name:tag .` |
| Build no cache | `docker build --no-cache -t name .` |
| List images | `docker images` |
| Remove image | `docker rmi name` |
| Run container | `docker run -p 3000:3000 name` |
| View Dockerfile history | `docker history name` |
| Inspect image | `docker inspect name` |

---

## Troubleshooting

### "File not found in build context"

**Cause:** File doesn't exist in build context directory.

**Fix:** 
- Check file exists
- Check you're running build from correct directory
- Can't copy from outside build context (no `../`)

---

### "npm: not found" or similar

**Cause:** Base image doesn't have the tool.

**Fix:** Use appropriate base image (e.g., `FROM node:18` for npm)

---

### "Container exits immediately"

**Cause:** No long-running process in CMD.

**Fix:** Make sure CMD starts a server/service, not a quick command.

---

### "Cannot remove intermediate container"

**Cause:** Layer failed to build.

**Fix:** Check error message, fix the problematic instruction.

---

## Best Practices Checklist

**DO:**
- ✓ Use specific version tags
- ✓ Copy dependency files before source code
- ✓ Combine RUN commands
- ✓ Clean up in same layer
- ✓ Use .dockerignore
- ✓ Use multi-stage for compiled apps
- ✓ Run as non-root user
- ✓ Use alpine/slim images

**DON'T:**
- ✗ Use `latest` tag
- ✗ Put secrets in Dockerfile
- ✗ Create unnecessary layers
- ✗ Run as root in production
- ✗ Copy node_modules
- ✗ Use RUN for startup commands

---

## Real-World Examples

### Express.js API

```dockerfile
FROM node:18-alpine
WORKDIR /app
COPY package*.json ./
RUN npm ci --only=production
COPY . .
EXPOSE 3000
CMD ["node", "server.js"]
```

---

### Flask API

```dockerfile
FROM python:3.11-slim
WORKDIR /app
COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt
COPY . .
EXPOSE 5000
CMD ["python", "app.py"]
```

---

### React App (Production)

```dockerfile
# Build stage
FROM node:18 AS build
WORKDIR /app
COPY package*.json ./
RUN npm install
COPY . .
RUN npm run build

# Production stage
FROM nginx:alpine
COPY --from=build /app/build /usr/share/nginx/html
EXPOSE 80
```

---

### Go Microservice

```dockerfile
# Build
FROM golang:1.21-alpine AS builder
WORKDIR /app
COPY go.* ./
RUN go mod download
COPY . .
RUN go build -o app

# Run
FROM alpine:latest
WORKDIR /app
COPY --from=builder /app/app .
EXPOSE 8080
CMD ["./app"]
```

---

## Layer Caching Explained

**How it works:**
```
Build 1:
├─ FROM node:18          [10 seconds]
├─ WORKDIR /app          [1 second]
├─ COPY package.json .   [1 second]
└─ RUN npm install       [60 seconds]  ← SLOW

Build 2 (only app.js changed):
├─ FROM node:18          [CACHED] 
├─ WORKDIR /app          [CACHED]
├─ COPY package.json .   [CACHED] ← Same file, use cache!
└─ RUN npm install       [CACHED] ← Super fast!

Build 3 (package.json changed):
├─ FROM node:18          [CACHED]
├─ WORKDIR /app          [CACHED]
├─ COPY package.json .   [1 second] ← Changed!
└─ RUN npm install       [60 seconds] ← Must run again
```

**Key:** Order instructions so frequently-changing files are LAST.

---

## Getting Help

```bash
# Dockerfile reference
https://docs.docker.com/engine/reference/builder/

# Best practices
https://docs.docker.com/develop/dev-best-practices/

# In terminal
docker build --help
```

---

## Quick Memory Aid

**The Three Rules:**
1. **Dependencies first, code last** (for caching)
2. **Combine commands** (fewer layers)
3. **Clean in same layer** (smaller image)

**Remember:**
- RUN = build time (install stuff)
- CMD = run time (start app)
- COPY before RUN (need files before using them)
- EXPOSE is documentation (still need -p)

---

**Need more help?** Check the full workbook or ask your instructor!
