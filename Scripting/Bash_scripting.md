# Bash Scripting Tutorial

This tutorial provides a solid foundation on how to create Bash scripts and automate daily system administration tasks. Bash scripting helps you understand automation concepts and prepares you for tools like **Ansible**, **Puppet**, and **Chef**.

---

## 🧩 Introduction

Bash scripting is widely used by system administrators and DevOps engineers to get things done efficiently. While tools like Ansible and Puppet provide advanced automation, Bash scripts remain essential for quick Linux automation tasks.

---

## 🗒️ What Are Scripts?

A Bash script is a plain text file containing a series of commands — the same ones you would type manually in the terminal. Anything you can execute on the command line can also be placed in a Bash script.

---

## ✏️ First Script

Create a simple script named `print.sh`:

```bash
#!/bin/bash
# A sample Bash script
echo "Hello World!"
```

**Explanation:**
- `#!/bin/bash` — the *shebang*, tells the system to interpret this file using Bash.
- `#` — comment character; lines starting with `#` are ignored by Bash.
- `echo` — prints text to the screen.

### Running the Script

Give it execute permission before running:

```bash
chmod 755 print.sh
./print.sh
```

Alternatively, run it directly through Bash:

```bash
bash print.sh
```

---

## 💾 Variables

Variables are temporary stores of information in memory.

### Defining and Accessing Variables

```bash
VAR1=123
echo $VAR1
```

### Command Line Arguments

```bash
#!/bin/bash
# A simple copy script
cp $1 $2
echo "Details for $2"
ls -lh $2
```

Run it as:

```bash
./copyscript.sh source_file target_file
```

---

## ⚙️ System Variables

| Variable | Description |
|-----------|-------------|
| `$0` | Script name |
| `$1–$9` | Command-line arguments |
| `$#` | Number of arguments |
| `$@` | All arguments |
| `$?` | Exit status of the last command |
| `$$` | Process ID of the current script |
| `$USER` | Username running the script |
| `$HOSTNAME` | Host machine name |
| `$SECONDS` | Time since script started |
| `$RANDOM` | Random number |
| `$LINENO` | Current line number |

---

## 🧮 Setting and Using Variables

```bash
intA=20
floatB=20.20
stringA="first_string"
DIR_PATH="/tmp"

echo "Value of integer A is $intA"
echo "Value of float B is $floatB"
echo "Value of string A is $stringA"
echo "Directory path is $DIR_PATH"
ls $DIR_PATH
```

---

## 🗨️ Quotes

Use quotes to handle spaces or special characters:

```bash
myvar="Hello World"
echo $myvar
```

Single quotes `' '` treat content literally, while double quotes `" "` allow variable substitution.

---

## 🔁 Command Substitution

Store command output in a variable:

```bash
files=$(ls)
echo $files
count=$(ls /etc | wc -l)
echo "There are $count entries in /etc"
```

---

## 🌍 Exporting Variables

```bash
var1=foo
export var1

#!/bin/bash
# demonstrate variable scope
echo "Exported variable: $var1"
```

To export variables permanently, add them to one of these:
- `~/.bashrc`
- `~/.profile`
- `/etc/profile`

---

## ⌨️ User Input

Use `read` to take input from users:

```bash
#!/bin/bash
echo "Please enter your name:"
read username
echo "Welcome, $username"
```

You can also use flags:
- `-p` : Prompt
- `-s` : Silent (for passwords)

Example:

```bash
read -p "Username: " uservar
read -sp "Password: " passvar
echo
echo "Thank you, $uservar"
```

---

## 🔎 If Statements

Basic structure:

```bash
if [ <condition> ]
then
    commands
fi
```

Example:

```bash
#!/bin/bash
if [ $1 -gt 100 ]
then
    echo "That’s a large number."
fi
date
```

**If–Else Example:**

```bash
if [ $a -eq $b ]
then
    echo "Equal"
else
    echo "Not Equal"
fi
```

---

## 🔂 Loops

### For Loop

```bash
for i in {1..3}
do
  echo "Number $i"
done
```

Loop through files:

```bash
for file in $(ls)
do
  echo "File: $file"
done
```

### While Loop

```bash
a=1
while [ $a -le 5 ]
do
  echo "Number $a"
  a=$((a+1))
done
```

---

## 💡 Real-Time Example: Install LAMP Stack

```bash
#!/bin/bash
sudo apt-get update -y && sudo apt-get upgrade -y
sudo apt-get install apache2 php mysql-server phpmyadmin -y
sudo systemctl restart apache2
echo "LAMP stack installed successfully!"
```

---

## 🗄️ Backup Script

```bash
#!/bin/bash
LOG_DIR='/tmp/scripts/logs'
BACKUP_DIR='/tmp/scripts/logs_backup'

mkdir -p $BACKUP_DIR

for i in $(cat backup_files.txt); do
  if [ -f $LOG_DIR/$i ]; then
    echo "Copying $i..."
    cp $LOG_DIR/$i $BACKUP_DIR
  else
    echo "$i not found, skipping."
  fi
done

tar -czvf logs_backup.tgz $BACKUP_DIR
echo "Backup complete."
```

---

## 🧰 Run Command on Remote Servers

```bash
#!/bin/bash
for host in $(cat hosts-dev)
do
  ssh vagrant@$host sudo yum install httpd -y
done
```

---

## 🔑 Setting Up SSH Keys

```bash
ssh-keygen -t rsa
ssh-copy-id user@server_ip
```

Now you can log in without a password.

---

## 🧾 Sample Maintenance Script (Nginx)

```bash
#!/bin/bash
if [ -f /var/run/nginx.pid ]
then
    echo "Nginx is running."
else
    echo "Starting nginx..."
    service nginx start
fi
```

Schedule it via cron:

```bash
* * * * * /opt/scripts/nginstart.sh
```

---

## 🧩 Example Jenkins Setup Script

```bash
#!/bin/bash
if yum --help &>/dev/null; then
  echo "RPM based OS detected"
  sudo yum install java-1.8.0-openjdk jenkins maven git -y
  sudo service jenkins start
else
  echo "Debian based OS detected"
  sudo apt-get update -y
  sudo apt-get install openjdk-8-jdk jenkins maven git -y
  sudo systemctl start jenkins
fi
```

---

## ✅ Summary

- Automate repetitive tasks with Bash scripting.
- Use variables, conditions, and loops to make scripts dynamic.
- Export and reuse variables for persistent environments.
- Practice automation using examples like backups, package installation, and monitoring.

---

## 🔗 Further Reading

Advanced Bash Scripting Guide: [tldp.org/LDP/abs/html](http://tldp.org/LDP/abs/html)
