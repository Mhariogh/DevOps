# Dockerfile Creation Workbook
## Learn to Build Your Own Docker Images

**Student Name:** ___________________  
**Date:** ___________________

---

## Introduction: What is a Dockerfile?

A Dockerfile is a text file that contains instructions for building a Docker image. Think of it like a recipe:
- **Recipe** = Dockerfile
- **Ingredients & Steps** = Instructions (FROM, RUN, COPY, etc.)
- **Finished Dish** = Docker Image
- **Serving the Dish** = Running a Container

---

## Part 1: Dockerfile Instructions - Understanding Each Command

### Exercise 1.1: Breaking Down a Simple Dockerfile

Here's a basic Dockerfile. Fill in what each instruction does:

```dockerfile
FROM node:18
WORKDIR /app
COPY package.json .
RUN npm install
COPY . .
EXPOSE 3000
CMD ["node", "server.js"]
```

| Instruction | What does it do? | Is it required? |
|-------------|------------------|-----------------|
| `FROM node:18` | | |
| `WORKDIR /app` | | |
| `COPY package.json .` | | |
| `RUN npm install` | | |
| `COPY . .` | | |
| `EXPOSE 3000` | | |
| `CMD ["node", "server.js"]` | | |

**Questions:**

1. Why do we `COPY package.json .` before `COPY . .`?

**Your Answer:**
___________________________________________________________________________
___________________________________________________________________________

2. What's the difference between `RUN` and `CMD`?

**Your Answer:**
___________________________________________________________________________
___________________________________________________________________________

3. What does the `.` mean in `COPY package.json .`?

**Your Answer:**
___________________________________________________________________________

---

### Exercise 1.2: FROM Instruction

The `FROM` instruction specifies the base image.

**Match the use case with the appropriate base image:**

| Use Case | Base Image |
|----------|------------|
| Python web application | A. `nginx:alpine` |
| Node.js application | B. `python:3.11` |
| Static website | C. `node:18` |
| Java application | D. `openjdk:17` |

**Your Answers:**
1. Python web app: _____
2. Node.js app: _____
3. Static website: _____
4. Java app: _____

**Question:** What does `:alpine` mean in `node:18-alpine`?

**Your Answer:**
___________________________________________________________________________

---

### Exercise 1.3: COPY vs ADD

Both `COPY` and `ADD` can copy files, but they're different.

**For each scenario, which should you use?**

| Scenario | COPY or ADD? | Why? |
|----------|--------------|------|
| Copy source code from local folder | | |
| Extract a tar.gz file into the image | | |
| Copy a config file | | |
| Download file from URL | | |

**General Rule:** Which one should you use in most cases?

**Your Answer:**
___________________________________________________________________________

---

### Exercise 1.4: RUN Instruction

`RUN` executes commands during image build.

**Fix these inefficient Dockerfiles:**

**Example 1 (Multiple RUN commands):**
```dockerfile
FROM ubuntu:22.04
RUN apt-get update
RUN apt-get install -y curl
RUN apt-get install -y git
RUN apt-get install -y vim
```

**Write a better version:**
```dockerfile
FROM ubuntu:22.04


```

**Why is your version better?**
___________________________________________________________________________

---

**Example 2 (Not cleaning up):**
```dockerfile
FROM ubuntu:22.04
RUN apt-get update && apt-get install -y python3
```

**Write a better version that reduces image size:**
```dockerfile
FROM ubuntu:22.04


```

**What did you add and why?**
___________________________________________________________________________

---

### Exercise 1.5: CMD vs ENTRYPOINT

Both define what runs when container starts, but differently.

**Fill in the table:**

| Aspect | CMD | ENTRYPOINT |
|--------|-----|------------|
| Can be overridden from command line? | | |
| Good for default commands? | | |
| Good for executables? | | |
| Format (JSON array example) | | |

**Scenario Questions:**

1. You're building a web server image. Which should you use?

**Your Answer:**
___________________________________________________________________________

2. You're building a utility tool (like `curl`). Which should you use?

**Your Answer:**
___________________________________________________________________________

---

### Exercise 1.6: EXPOSE Instruction

```dockerfile
EXPOSE 8080
```

**True or False Questions:**

1. EXPOSE actually publishes the port to the host machine.  
   **Your Answer:** ___________

2. EXPOSE is documentation showing which port the container listens on.  
   **Your Answer:** ___________

3. You still need `-p` flag when running the container to access the port.  
   **Your Answer:** ___________

4. You can expose multiple ports in one Dockerfile.  
   **Your Answer:** ___________

**Question:** How would you expose ports 80 AND 443?

**Your Answer:**
```dockerfile

```

---

### Exercise 1.7: ENV - Environment Variables

```dockerfile
ENV NODE_ENV=production
ENV PORT=3000
```

**Questions:**

1. When are ENV variables set - at build time or run time?

**Your Answer:**
___________________________________________________________________________

2. How can you override an ENV variable when running the container?

**Your Answer:**
___________________________________________________________________________

3. Write ENV instructions for a database connection:
   - DB_HOST with value "localhost"
   - DB_PORT with value "5432"
   - DB_NAME with value "myapp"

**Your Answer:**
```dockerfile



```

---

## Part 2: Build Your First Dockerfile

### Challenge 2.1: Simple Python Application

You have a Python Flask application with these files:
```
my-app/
  ├── app.py
  └── requirements.txt
```

The app runs with: `python app.py`

**Task:** Write a complete Dockerfile

**Requirements:**
- Use Python 3.11 base image
- Set working directory to `/app`
- Copy requirements.txt first and install dependencies
- Copy all application files
- Expose port 5000
- Run the application

**Write your Dockerfile:**
```dockerfile
# Your Dockerfile here













```

---

### Challenge 2.2: Node.js Application

You have a Node.js application:
```
my-node-app/
  ├── server.js
  ├── package.json
  └── package-lock.json
```

The app runs with: `npm start`

**Task:** Write an optimized Dockerfile

**Requirements:**
- Use Node 18 base image
- Set working directory to `/app`
- Copy package files first (for layer caching)
- Install dependencies
- Copy source code
- Expose port 3000
- Start the application

**Write your Dockerfile:**
```dockerfile
# Your Dockerfile here













```

**Question:** Why did we copy package.json before copying all other files?

**Your Answer:**
___________________________________________________________________________
___________________________________________________________________________

---

### Challenge 2.3: Static Website with Nginx

You have a static HTML website:
```
my-website/
  ├── index.html
  ├── style.css
  └── script.js
```

**Task:** Create a Dockerfile to serve this with Nginx

**Hint:** Nginx serves files from `/usr/share/nginx/html`

**Write your Dockerfile:**
```dockerfile
# Your Dockerfile here









```

---

## Part 3: Debugging Broken Dockerfiles

### Debug 3.1

```dockerfile
FROM node:18
COPY . .
RUN npm install
WORKDIR /app
CMD ["npm", "start"]
```

**What's wrong with this Dockerfile?**
___________________________________________________________________________

**Write the corrected version:**
```dockerfile





```

---

### Debug 3.2

```dockerfile
FROM python:3.11
WORKDIR /app
COPY . .
RUN pip install -r requirements.txt
EXPOSE 5000
RUN python app.py
```

**What's wrong with the last line?**
___________________________________________________________________________

**How should it be fixed?**
```dockerfile
# Write just the corrected last line:

```

---

### Debug 3.3

```dockerfile
FROM ubuntu:22.04
COPY app.py /app/
RUN python app.py
```

**What's missing that will cause this to fail?**
___________________________________________________________________________

**Write the corrected Dockerfile:**
```dockerfile




```

---

### Debug 3.4

```dockerfile
FROM node:18
WORKDIR /app
RUN npm install
COPY package.json .
COPY . .
CMD ["npm", "start"]
```

**What's wrong with the order of instructions?**
___________________________________________________________________________

**Why does this matter?**
___________________________________________________________________________

**Write the corrected version:**
```dockerfile






```

---

## Part 4: Layer Caching & Optimization

### Exercise 4.1: Understanding Layers

Every instruction in a Dockerfile creates a layer.

**This Dockerfile:**
```dockerfile
FROM node:18           # Layer 1
WORKDIR /app           # Layer 2
COPY package.json .    # Layer 3
RUN npm install        # Layer 4
COPY . .               # Layer 5
CMD ["npm", "start"]   # Layer 6
```

**Questions:**

1. If you only change `app.js`, which layers get rebuilt?

**Your Answer:**
___________________________________________________________________________

2. If you add a new npm package to package.json, which layers rebuild?

**Your Answer:**
___________________________________________________________________________

3. Why is this layer ordering important?

**Your Answer:**
___________________________________________________________________________
___________________________________________________________________________

---

### Exercise 4.2: Optimize This Dockerfile

**Given this inefficient Dockerfile:**

```dockerfile
FROM python:3.11
COPY . /app
WORKDIR /app
RUN pip install -r requirements.txt
RUN pip install pytest
RUN apt-get update
RUN apt-get install -y curl
RUN apt-get install -y git
CMD ["python", "app.py"]
```

**Rewrite it to be more efficient:**

```dockerfile
# Your optimized version here













```

**Explain what you changed and why:**
___________________________________________________________________________
___________________________________________________________________________
___________________________________________________________________________

---

## Part 5: Multi-Stage Builds (Advanced)

Multi-stage builds help create smaller images by separating build and runtime environments.

### Exercise 5.1: Understanding Multi-Stage Builds

**This is a single-stage Dockerfile:**
```dockerfile
FROM node:18
WORKDIR /app
COPY package.json .
RUN npm install
COPY . .
RUN npm run build
CMD ["node", "dist/server.js"]
```

**Problem:** The final image includes:
- Node.js build tools
- Source code
- All dev dependencies
- Build artifacts

**Question:** What can we remove from the final image?

**Your Answer:**
___________________________________________________________________________
___________________________________________________________________________

---

### Exercise 5.2: Create a Multi-Stage Build

**Task:** Convert this to a multi-stage build:

```dockerfile
FROM node:18
WORKDIR /app
COPY package.json .
RUN npm install
COPY . .
RUN npm run build
CMD ["node", "dist/server.js"]
```

**Your multi-stage Dockerfile:**

```dockerfile
# Build stage



# Production stage






```

**Explain what each stage does:**

**Build stage:**
___________________________________________________________________________

**Production stage:**
___________________________________________________________________________

---

## Part 6: .dockerignore File

### Exercise 6.1: Understanding .dockerignore

The `.dockerignore` file tells Docker which files NOT to copy.

**You have this project structure:**
```
my-app/
  ├── src/
  ├── node_modules/
  ├── .git/
  ├── .env
  ├── README.md
  ├── package.json
  └── Dockerfile
```

**Task:** Create a .dockerignore file

**Which files should you exclude and why?**

```
# Write your .dockerignore file









```

**Explain your choices:**
___________________________________________________________________________
___________________________________________________________________________

---

## Part 7: Building and Testing

### Exercise 7.1: Build Commands

**You have a Dockerfile in current directory. Write the commands to:**

1. Build an image named "my-app" with tag "v1.0":

```bash

```

2. Build an image named "my-app" with tag "latest":

```bash

```

3. Build using a Dockerfile in a different directory:

```bash

```

4. Build and view all build steps:

```bash

```

---

### Exercise 7.2: Build Context

**Question:** What is the "build context"?

**Your Answer:**
___________________________________________________________________________
___________________________________________________________________________

**This command:**
```bash
docker build -t my-app .
```

**What does the `.` represent?**
___________________________________________________________________________

**If your project is in `/home/user/my-app/`, where should you run the build command?**
___________________________________________________________________________

---

## Part 8: Real-World Scenarios

### Scenario 8.1: Full-Stack Application

**You're building a React + Node.js app:**

```
my-fullstack-app/
  ├── client/
  │   ├── src/
  │   ├── public/
  │   └── package.json
  ├── server/
  │   ├── index.js
  │   └── package.json
  └── Dockerfile
```

**The client needs to be built (creates static files)**  
**The server serves the API and the built client**

**Task:** Write a Dockerfile that:
1. Builds the React client
2. Copies built files to server
3. Runs the Node server

```dockerfile
# Your Dockerfile here



















```

---

### Scenario 8.2: Python Data Science Application

**You have a Jupyter notebook application:**
- Uses Python 3.11
- Needs packages: jupyter, pandas, numpy, matplotlib
- requirements.txt contains all dependencies
- Jupyter runs on port 8888
- Start command: `jupyter notebook --ip=0.0.0.0 --allow-root`

**Write the Dockerfile:**

```dockerfile
# Your Dockerfile here













```

---

### Scenario 8.3: Microservice with Dependencies

**You're building a Go microservice that:**
- Connects to PostgreSQL database
- Needs these environment variables:
  - DB_HOST
  - DB_PORT (default: 5432)
  - DB_NAME
- Listens on port 8080
- Binary is built with: `go build -o app`

**Write the Dockerfile:**

```dockerfile
# Your Dockerfile here















```

---

## Part 9: Best Practices Quiz

### Mark each statement as GOOD or BAD practice:

1. Using `latest` tag for base images in production  
   **Your Answer:** _________

2. Running containers as root user  
   **Your Answer:** _________

3. Installing multiple packages in one RUN command  
   **Your Answer:** _________

4. Copying package files before source code  
   **Your Answer:** _________

5. Including secrets/passwords in Dockerfile  
   **Your Answer:** _________

6. Using specific version tags (like `node:18.17`)  
   **Your Answer:** _________

7. Cleaning up apt cache after installing packages  
   **Your Answer:** _________

8. Having many EXPOSE instructions  
   **Your Answer:** _________

9. Using COPY instead of ADD for local files  
   **Your Answer:** _________

10. Creating many small layers for each command  
    **Your Answer:** _________

---

## Part 10: Create Your Own

### Final Project: Containerize Your Own Application

**Choose an application type:**
- [ ] Web application
- [ ] API server
- [ ] Database-backed application
- [ ] CLI tool
- [ ] Other: _______________

**Describe your application:**
___________________________________________________________________________
___________________________________________________________________________

**What language/framework?**
___________________________________________________________________________

**What dependencies does it need?**
___________________________________________________________________________
___________________________________________________________________________

**What port(s) does it use?**
___________________________________________________________________________

**How do you run it?**
___________________________________________________________________________

**Write your complete Dockerfile:**

```dockerfile
# Application: _________________
# Author: _____________________
# Date: _______________________


























```

**Write your .dockerignore:**

```
# .dockerignore file






```

**Write the commands to build and run:**

```bash
# Build command:


# Run command:


```

---

## Part 11: Troubleshooting Common Errors

### For each error message, explain what it means and how to fix it:

**Error 1:**
```
Step 3/8 : RUN npm install
 ---> Running in abc123
/bin/sh: 1: npm: not found
```

**What's wrong?**
___________________________________________________________________________

**How to fix?**
___________________________________________________________________________

---

**Error 2:**
```
COPY failed: file not found in build context
```

**What's wrong?**
___________________________________________________________________________

**How to fix?**
___________________________________________________________________________

---

**Error 3:**
```
failed to solve with frontend dockerfile.v0: 
failed to create LLB definition: 
no command specified
```

**What's wrong?**
___________________________________________________________________________

**How to fix?**
___________________________________________________________________________

---

**Error 4:**
```
Error response from daemon: 
Conflict. The container name "/my-app" is already in use
```

**What's wrong?**
___________________________________________________________________________

**How to fix?**
___________________________________________________________________________

---

## Self-Assessment Checklist

Rate your understanding (1-5, where 5 is "I can teach this to someone else"):

- [ ] What a Dockerfile is and why we need it: _____
- [ ] FROM instruction and base images: _____
- [ ] COPY vs ADD: _____
- [ ] RUN vs CMD vs ENTRYPOINT: _____
- [ ] WORKDIR instruction: _____
- [ ] EXPOSE instruction: _____
- [ ] ENV variables: _____
- [ ] Layer caching and optimization: _____
- [ ] .dockerignore file: _____
- [ ] Building images with docker build: _____
- [ ] Multi-stage builds: _____
- [ ] Debugging Dockerfile errors: _____

**What do you still need help with?**
___________________________________________________________________________
___________________________________________________________________________
___________________________________________________________________________

**What will you try building next?**
___________________________________________________________________________
___________________________________________________________________________

---

## Quick Reference Summary

**Basic Dockerfile Structure:**
```dockerfile
FROM <base-image>
WORKDIR <directory>
COPY <source> <destination>
RUN <command>
EXPOSE <port>
CMD ["executable", "param1"]
```

**Build Command:**
```bash
docker build -t <image-name>:<tag> <build-context>
```

**Run Built Image:**
```bash
docker run -p <host-port>:<container-port> <image-name>
```

---

**Teacher's Notes:**
___________________________________________________________________________
___________________________________________________________________________
___________________________________________________________________________
