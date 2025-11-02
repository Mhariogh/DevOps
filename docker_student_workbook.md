# Docker Practice Workbook
## Understanding Multi-Container Applications

**Student Name:** ___________________  
**Date:** ___________________

---

## Part 1: Command Breakdown - Do You Really Understand?

For each command below, fill in what each part does:

### Exercise 1.1: Breaking Down `docker run`

```bash
docker run -d -p 3000:3000 --name my-app my-image
```

| Part | What does it do? | What happens if you remove it? |
|------|------------------|-------------------------------|
| `docker run` | | |
| `-d` | | |
| `-p 3000:3000` | | |
| `--name my-app` | | |
| `my-image` | | |

**Question:** What's the difference between `-p 3000:3000` and `-p 8080:3000`?

**Your Answer:**
___________________________________________________________________________

---

### Exercise 1.2: Understanding Volumes

```bash
docker run -d -v todo-db:/etc/todos my-app
```

| Part | What does it do? |
|------|------------------|
| `-v todo-db:/etc/todos` | |
| `todo-db` (before the colon) | |
| `/etc/todos` (after the colon) | |

**Question:** What's the difference between `-v todo-db:/etc/todos` and `-v /my/local/path:/etc/todos`?

**Your Answer:**
___________________________________________________________________________

---

### Exercise 1.3: Network Commands

```bash
docker network create todo-app
docker run -d --network todo-app --network-alias mysql -e MYSQL_ROOT_PASSWORD=secret mysql:8.0
```

**Fill in the blanks:**

1. `docker network create` creates a ________________________
2. `--network todo-app` connects the container to ________________________
3. `--network-alias mysql` allows other containers to find this container using the name ________________________
4. `-e MYSQL_ROOT_PASSWORD=secret` sets an ________________________ inside the container

**Question:** Why do containers need to be on the same network to communicate?

**Your Answer:**
___________________________________________________________________________

---

## Part 2: Predict the Outcome

For each scenario, predict what will happen and explain why:

### Scenario 2.1
```bash
docker run -d -p 3000:3000 --name app1 my-image
docker run -d -p 3000:3000 --name app2 my-image
```

**What will happen?**
___________________________________________________________________________

**Why?**
___________________________________________________________________________

---

### Scenario 2.2
```bash
docker run -d --name my-app my-image
docker run -d --name my-app my-image
```

**What will happen?**
___________________________________________________________________________

**Why?**
___________________________________________________________________________

---

### Scenario 2.3
```bash
docker run -d -p 3000:3000 --name app1 my-image
docker stop app1
docker run -d -p 3000:3000 --name app2 my-image
```

**What will happen?**
___________________________________________________________________________

**Why?**
___________________________________________________________________________

---

### Scenario 2.4
You have two containers on different networks:
- Container A on `network-1`
- Container B on `network-2`

**Can Container A ping Container B? Why or why not?**
___________________________________________________________________________

---

## Part 3: Debug These Broken Commands

Each command below has an error. Find it and explain how to fix it:

### Debug 3.1
```bash
docker run -d -p 80:80:80 nginx
```

**What's wrong?**
___________________________________________________________________________

**How to fix it:**
___________________________________________________________________________

---

### Debug 3.2
```bash
docker run -d --name my-app -v /data my-image
```
(Hint: This isn't technically wrong, but there's a better practice)

**What could be improved?**
___________________________________________________________________________

**Why?**
___________________________________________________________________________

---

### Debug 3.3
```bash
docker run -d --network todo-app mysql:8.0
```
(This container keeps restarting and crashing)

**What's missing?**
___________________________________________________________________________

---

### Debug 3.4
```bash
docker run -d -p 3000:80 --name app my-image
```
(You try to access localhost:80 in your browser but nothing works)

**What's wrong?**
___________________________________________________________________________

**How to access the application:**
___________________________________________________________________________

---

## Part 4: Build From Scratch

### Challenge 4.1: Two-Container Application

**Task:** Set up a simple two-container application without looking at notes:

1. Create a network called `my-network`
2. Run a MySQL container with:
   - Name: `my-database`
   - Network: `my-network`
   - Network alias: `db`
   - Root password: `mypassword`
3. Run an application container that connects to this database

**Write your commands here:**

```bash
# Command 1: Create network


# Command 2: Run MySQL


# Command 3: Run your app


```

---

### Challenge 4.2: Volume Persistence Test

**Task:** Prove that volumes persist data even when containers are deleted.

**Write the steps you'll take:**

1. ___________________________________________________________________________
2. ___________________________________________________________________________
3. ___________________________________________________________________________
4. ___________________________________________________________________________

**Write the actual commands:**

```bash
# Your commands here






```

---

## Part 5: Concept Questions

### Question 5.1
Explain in your own words: **What is a Docker volume and why do we need it?**

**Your Answer:**
___________________________________________________________________________
___________________________________________________________________________
___________________________________________________________________________

---

### Question 5.2
Explain in your own words: **What is a Docker network and why do we need it?**

**Your Answer:**
___________________________________________________________________________
___________________________________________________________________________
___________________________________________________________________________

---

### Question 5.3
**When would you use `-d` flag and when would you NOT use it?**

**Your Answer:**
___________________________________________________________________________
___________________________________________________________________________

---

### Question 5.4
**What's the difference between `docker stop` and `docker rm`?**

**Your Answer:**
___________________________________________________________________________
___________________________________________________________________________

---

## Part 6: Real-World Scenario

### Scenario: Blog Application

You need to set up a blog application with the following requirements:

- A **WordPress** container (image: `wordpress:latest`)
- A **MySQL** database container (image: `mysql:8.0`)
- WordPress needs these environment variables:
  - `WORDPRESS_DB_HOST=db:3306`
  - `WORDPRESS_DB_USER=wpuser`
  - `WORDPRESS_DB_PASSWORD=wppass`
  - `WORDPRESS_DB_NAME=wordpress`
- MySQL needs these environment variables:
  - `MYSQL_DATABASE=wordpress`
  - `MYSQL_USER=wpuser`
  - `MYSQL_PASSWORD=wppass`
  - `MYSQL_ROOT_PASSWORD=rootpass`
- WordPress should be accessible on port 8080 of your machine
- Both containers should persist their data
- Both containers should communicate with each other

**Write your complete solution:**

```bash
# Step 1: Create network


# Step 2: Create volume for MySQL data


# Step 3: Create volume for WordPress data


# Step 4: Run MySQL container


# Step 5: Run WordPress container


```

---

## Part 7: Command Reference Quick Quiz

Without looking at notes, write the command for each task:

### 7.1 List all running containers
```bash

```

### 7.2 List all containers (including stopped ones)
```bash

```

### 7.3 View logs of a container named "my-app"
```bash

```

### 7.4 Stop a container named "my-app"
```bash

```

### 7.5 Remove a container named "my-app"
```bash

```

### 7.6 List all Docker networks
```bash

```

### 7.7 List all Docker volumes
```bash

```

### 7.8 Execute a bash command inside a running container named "my-app"
```bash

```

### 7.9 Remove all stopped containers
```bash

```

### 7.10 View all images on your system
```bash

```

---

## Part 8: Troubleshooting Challenge

For each problem, write what command(s) you would run to diagnose the issue:

### Problem 8.1
"My container started but I can't access the application on localhost:3000"

**Diagnostic commands:**
```bash



```

**What to check:**
___________________________________________________________________________

---

### Problem 8.2
"My container keeps restarting every few seconds"

**Diagnostic commands:**
```bash



```

**What to check:**
___________________________________________________________________________

---

### Problem 8.3
"My database container lost all its data when I restarted it"

**What went wrong?**
___________________________________________________________________________

**How to prevent this:**
___________________________________________________________________________

---

## Part 9: Advanced Understanding

### Question 9.1
You run this command:
```bash
docker run -d -p 8080:80 -v mydata:/app/data --name web nginx
```

Now answer:
1. What port do you use in your browser? _____________
2. Where is the data stored on your host machine? _____________
3. If you delete this container, is the data lost? _____________
4. How would you run a second nginx container? _____________

---

### Question 9.2
**Explain the difference between:**

a) Named volume vs bind mount:
___________________________________________________________________________
___________________________________________________________________________

b) Bridge network vs host network:
___________________________________________________________________________
___________________________________________________________________________

---

## Part 10: Create Your Own

### Final Challenge
Design a three-container application of your choice (e.g., web app + database + cache).

**Describe your application:**
___________________________________________________________________________
___________________________________________________________________________

**Draw or describe the architecture:**




**Write all the commands needed to set it up:**

```bash













```

---

## Self-Assessment

Rate your understanding (1-5, where 5 is "I can explain this to someone else"):

- [ ] `docker run` and its flags: _____
- [ ] Docker volumes: _____
- [ ] Docker networks: _____
- [ ] Port mapping: _____
- [ ] Environment variables: _____
- [ ] Container lifecycle (start, stop, rm): _____
- [ ] Debugging container issues: _____

**What concepts do you still need help with?**
___________________________________________________________________________
___________________________________________________________________________

---

**Teacher's Notes:**
___________________________________________________________________________
___________________________________________________________________________
___________________________________________________________________________
