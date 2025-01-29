# <div align="center">Inception Step by Step</div>
This project aims to broaden your knowledge of system administration by using **Docker**.

In this guide, I'll walk you through setting up the required infrastructure step by step, making it simple and enjoyable. Take your time to read, check out the shared links, experiment, and have fun while learning!

# Table of Contents
1. [Introduction to Docker](#Introduction-to-Docker)
2. [NGINX Container Setup](#NGINX-Container-Setup)
3. [MariaDB Container Setup](#MariaDB-Container-Setup)
4. [WordPress Container Setup with PHP-FPM](#WordPress-Container-Setup-with-PHP-FPM)
5. [Docker-Compose Setup](#Docker-Compose-Setup)
6. [Understanding Networking in Docker](#Understanding-Networking-in-Docker)
7. [Finalizing the Project](#Finalizing-the-Project)
8. [Conclusion](#Conclusion)

# Introduction to Docker
## What is Docker?
Docker is an open-source platform for developing, shipping, and running applications in an isolated environment called a `container`. It enables you to separate applications from your infrastructure, ensuring quick and consistent software delivery.

Containers has their own OS and all, except that unlike virtual machines they don’t simulate the entire computer, but rather create a sand boxed environment that pretends to be a virtual machine. They are `lightweight` and contain everything needed to run the application, so you don't need to rely on what's installed on the host. You can share containers while you work, and be sure that everyone you share with gets the same container that works in the same way.

## Why Use Docker?
### Advantages of Docker:
- Solves  the `"Works on my machine"` problem. Docker containers ensure that applications run consistently across different environments by bundling the application with all its dependencies.
- Docker containers are lightweight and provide isolated environments for running applications.
- Docker containers are portable and can run on any platform that supports Docker (`Linux`, `macOS`, `Windows`, `cloud platforms`).
- Applications packaged in Docker containers can be easily moved between `development`, `testing`, and `production` systems.
- Docker images include everything needed to run an application: `code`, `runtime`, `libraries`, and `dependencies`.
- Faster startup times and reduced resource usage compared to VMs, because they share the host operating system's kernel.

## Docker Architecture
Docker operates using a client-server architecture, consisting of:

1. **`Docker Client`:** A command-line interface for interacting with Docker.
2. **`Docker Daemon`:** Handles the heavy lifting of building, running, and managing containers.
3. **`Docker Registries`:** Store Docker images. Like `Docker Hub` (public registry) and private registries.

## Docker Objects
### Images
An image is a read-only template with instructions for creating a container.
Use a `Dockerfile` to build images. Each step in a Dockerfile creates a `layer`, making updates efficient.

### Containers
A container is a runnable instance of an image.
Containers are isolated from one another and the host system by default.

### Volumes
Volumes in Docker are a feature for managing persistent data in containers. Containers are `ephemeral` by nature, meaning data inside them is lost when the container stops or is removed. Volumes provide a way to persist and share data between containers and the host system, ensuring data remains available even if a container is restarted, stopped, or deleted.

#### Types of Volumes
1. **Named Volumes:**
- Created and managed by Docker.
- Stored in Docker's managed storage directory on the host (e.g., `/var/lib/docker/volumes`).
- Good for long-term data persistence.

2. **Bind Mounts:**
- Maps a specific directory or file on the host to a container.
- More flexibility because you control the exact location of the data.
- Useful for local development or when sharing specific files.

## Essential Docker Commands
### Basic Commands
```bash
docker run <image>        # Run a container from an image
docker ps                 # List running containers
docker stop <container>   # Stop a running container
docker start <container>  # Start a stopped container
docker rm <container>     # Remove a container
docker rmi <image>        # Remove an image
```

### Image Management
```bash
docker images                  # List locally stored images
docker build -t <tag> <path>   # Build an image from a Dockerfile
docker pull <image>            # Pull an image from Docker Hub
docker push <image>            # Push an image to a registry
```

### Container Interaction
```bash
docker exec -it <container> <command>  # Run a command inside a running container
docker logs <container>               # Display container logs
docker stats                          # Show resource usage
```

### System Cleanup
```bash
docker system prune      # Clean up unused containers, images, networks, and volumes
docker volume prune      # Remove unused volumes
docker network prune     # Remove unused networks
```

## Understanding PID 1 in Docker Containers
In Docker containers, `PID 1` is the process ID of the first process started within the container. This process is critical because:
1. **Lifecycle Management:** When the process with PID 1 exits, the container stops.
2. **Signal Handling:** PID 1 is responsible for handling signals (e.g., `SIGTERM`, `SIGKILL`). However, many applications don't handle signals correctly when running as PID 1, which can cause issues during container shutdown.
3. **Zombie Process Reaping:** PID 1 is responsible for reaping zombie processes (child processes that have terminated but are not properly cleaned up). If PID 1 does not perform this task, it can lead to resource leaks.

## Explore more about Docker and its Uses
- [Docker documentation](https://docs.docker.com/get-started/docker-overview/)
- [A Great Starter Video](https://www.youtube.com/watch?v=pg19Z8LL06w)

---

# NGINX Container Setup
## What is NGINX?
NGINX is a powerful open-source web server and reverse proxy software, renowned for its high performance, scalability, and reliability. It's widely adopted in modern web development and system administration for tasks such as:

- `Reverse proxying`: Directing client requests to different servers based on predefined rules. 
- `Load balancing`: Distributing incoming traffic across multiple servers to optimize resource utilization and ensure availability.
- `Caching`: Storing frequently requested content to reduce server load and improve response times.
- `Serving static files`: Efficiently delivering images, CSS, JavaScript, and other static assets.
- `Providing HTTPS server capabilities`: Providing encryption for secure communication between clients and servers.

In this project, NGINX serves as the web server for the WordPress site, handling secure connections and static file delivery.

## Learn more about NGINX
Before diving into the setup, take some time to explore these resources for a deeper understanding of how NGINX works: ⬇️
- [NGINX Official Documentation](https://nginx.org/en/docs/)
- [NGINX Tutorial (Youtube)](https://www.youtube.com/watch?v=9t9Mp0BGnyI&t=1639s)
- [Understanding NGINX Configuration](https://www.digitalocean.com/community/tutorials/understanding-the-nginx-configuration-file-structure-and-configuration-contexts)

By familiarizing yourself with these resources, you'll better understand how to utilize NGINX effectively in your projects.

## Dockerfile Explanation
This section provides a detailed explanation of the `Dockerfile`, outlining each step and why it is essential in setting up the Docker container for NGINX.

Now, you should be ready to start creating the NGINX container! By this point, you understand how to write a `Dockerfile`, configure NGINX, and how it works. You've also gone through the project requirements multiple times and have a clear understanding of what needs to be done.

1. **Base Image**
```dockerfile
FROM debian:bullseye
```
- The base image `debian:bullseye` provides a lightweight and stable Linux environment.
- Using a minimal image reduces unnecessary bloat and focuses only on the essentials required for NGINX and SSL setup.
- Debian is a common choice for server environments due to its reliability and support for many packages.

2. **Update and Install Packages**
```dockerfile
RUN apt update -y && apt upgrade -y && \
    apt install -y nginx openssl
```
**- Why Update and Upgrade?**
  - `apt update` ensures the package list is current, retrieving the latest versions from the repositories.
  - `apt upgrade` updates installed packages to their latest stable versions for security and performance improvements.

**- Why Install These Packages?**

  - `nginx`: This is the core of the container, acting as the web server for the WordPress site.
  - `openssl`: Provides tools for creating SSL/TLS certificates, enabling secure HTTPS connections.

3. **Generate SSL Certificate**

```dockerfile
RUN mkdir -p /etc/nginx/ssl && \
    openssl req -x509 -nodes \
    -days 365 \
    -keyout /etc/nginx/ssl/inception.key \
    -out /etc/nginx/ssl/inception.crt \
    -subj "/CN=${DOMAIN_NAME}"
```
**Why Use SSL?**

SSL/TLS encrypts communication between the server and clients, ensuring data security and trust. A self-signed certificate is created here for testing purposes:
- Command Breakdown:
  - `mkdir -p /etc/nginx/ssl`: Creates the directory to store SSL files. The `-p` flag ensures parent directories are created if they don't exist.
  - `openssl req`: Initiates certificate creation.
    - `-x509`: Creates an X.509 certificate.
    - `-nodes`: No password is required for the private key.
    - `-days 365`: Sets the certificate validity to 1 year.
    - `-subj`: Defines certificate details.

4. **Prepare NGINX Directories**
```dockerfile
RUN mkdir -p /var/www/wordpress /var/run/nginx && \
    chmod 755 /var/www/wordpress && \
    chown -R www-data:www-data /var/www/wordpress
```
- `/var/www/wordpress`: Directory for WordPress.
- `/var/run/nginx`: Required for NGINX runtime operations.

Ownership and permissions are set for the `www-data` user, which NGINX uses to serve content. Without this, you could encounter "permission denied" errors.

5. **Copy Configuration**

```dockerfile
COPY conf/nginx.conf /etc/nginx/nginx.conf
```

The custom `nginx.conf` file  is copied into the container at `/etc/nginx/nginx.conf`. *(We will delve deeper into `nginx.conf` in its own section)*

**- Why Custom Configuration?**
- The default NGINX configuration may not support the specific requirements of this project, such as WordPress or reverse proxying.
- The custom configuration will be tailored to enable TLS, define root directories, and set up PHP processing.

7. **Set the Default Command**
```dockerfile
CMD ["nginx", "-g", "daemon off;"]
```
**- Purpose of This Command:**
  - Runs NGINX in the foreground (`daemon off`), ensuring the container stays alive.
  - If NGINX runs in the background (`daemon on`), the container will stop immediately after execution.

**- Why Use CMD?**
  - The `CMD` instruction sets the default command that the container executes when started.
  - It ensures NGINX is ready to serve requests as soon as the container starts.

By following this `Dockerfile`, you'll have a secure, performant NGINX container configured to serve your WordPress site with HTTPS enabled.

## Nginx Configuration File (nginx.conf)

The way **NGINX** and its modules work is determined by the configuration file. By default, the configuration file is named `nginx.conf` and is located in one of the following directories:

- `/usr/local/nginx/conf`
- `/etc/nginx`
- `/usr/local/etc/nginx`

Below, we'll break down the critical components of the configuration file to understand their roles and purpose.

1. **Events Block**

The `events` block is a placeholder necessary for the NGINX configuration:

```nginx
events {}
```

2. **HTTP Block**

Defines the core `HTTP` settings and behavior:

```nginx
http {
    # Additional configuration can go here
    ...
}
```

3. **HTTPS Server Block**

The `server` block configures an HTTPS server. In this project, it is responsible for serving the WordPress site securely:

```nginx
server {
    listen 443 ssl;
    ssl_protocols TLSv1.2 TLSv1.3;
    ssl_certificate /etc/nginx/ssl/inception.crt;
    ssl_certificate_key /etc/nginx/ssl/inception.key;

    root /var/www/wordpress;
    server_name ${DOMAIN_NAME};
    index index.php index.html index.htm;

    # Add other configuration blocks here
    ...
}
```
- `listen 443 ssl;`: Specifies that the server will listen for HTTPS traffic on port 443.
- `SSL Protocols`: Restricts connections to use TLSv1.2 and TLSv1.3 for better security.
- `SSL Certificate and Key`: Defines the paths to the SSL certificate and private key files.
- `root` and `index`: Specifies the root directory for WordPress files and default files to serve.
- `server_name`: Specifies the domain name. For testing purposes, you can set it to localhost for now.

4. **Location Blocks**

Defines rules for serving specific types of requests.

**`Root Location`**

Handles requests for static files or directories:

```nginx
location / {
    try_files $uri $uri/ =404;
}
```
- `$uri`: Tries to serve the requested file.
- `$uri/`: Tries to serve the requested directory.
- `=404`: Returns a 404 error if neither exists.

**`PHP Processing`**

Directs `.php` files to PHP-FPM for processing:

```nginx
location ~ \.php$ {
    include snippets/fastcgi-php.conf;
    fastcgi_pass wordpress:9000;
}
```
- Matches `.php` files for PHP-FPM processing.
- `fastcgi_pass wordpress:9000;` assumes a Docker container named `wordpress` is running PHP-FPM on port 9000.

## Testing the NGINX Container
To test your container, follow these steps:

1. Remove the PHP Location Block *(if PHP-FPM is not yet configured)*:
2. Build and Run the Docker Container:

- Open a terminal and navigate to the directory containing your `Dockerfile`.

- Run the following commands:

```bash
docker build -t nginx-img .
docker run -d --name nginx-container -p 443:443 nginx-img
```

Tip: If port 443 is blocked, bind the address to a different port (e.g., 8443):

```bash
docker run -d --name nginx-container -p 8443:443 nginx-img
```

3. Add a Test File:

- Run this command to create a simple HTML file inside the container:

```bash
docker exec -it nginx-container bash -c 'echo "<h1>Hello World!</h1>" > /var/www/wordpress/index.html'
```

4. Access the NGINX Server:

- Open a web browser and go to:
    * `https://localhost:443` (if you used port 443)
    * `https://localhost:8443` (if you used port 8443)

5. If you encounter issues, inspect the container logs for debugging:
```bash
docker logs nginx-container
```

---

# MariaDB Container Setup
## What is MariaDB ?
MariaDB Server is one of the most popular open-source relational databases. Created by the original developers of MySQL, it is designed to remain open-source and is widely used in cloud services and as the default database in many Linux distributions.

### Purpose
MariaDB serves as the database management system (DBMS) for storing WordPress data.

## MariaDB Setup
Here’s how we set up MariaDB in our Docker container.

### Dockerfile Explanation
```dockerfile
FROM debian:bullseye
```

- **Base Image:** As the subject requires (The containers must be built either from the penultimate stable
version of `Alpine` or `Debian`. The choice is yours.)

```dockerfile
RUN apt update -y && apt upgrade -y && \
    apt install -y mariadb-server && \
    apt clean && rm -rf /var/lib/apt/lists/*
```

- **Install MariaDB:** This command installs the MariaDB server and all necessary dependencies.
- **Clean Up:** Reduces image size by clearing unnecessary package lists.

```dockerfile
COPY conf/50-server.cnf /etc/mysql/mariadb.conf.d/50-server.cnf
COPY tools/mariadb.sh /usr/local/bin/mariadb.sh
```

- **Configuration Files:** These lines copy custom configuration files into the container:
* `50-server.cnf`: Defines MariaDB settings (port, user, socket, and data directory).
* `mariadb.sh`: A custom script for initializing the database and users.

```dockerfile
RUN chmod +x /usr/local/bin/mariadb.sh
```

- **Set Permissions:** Grants execution permissions to the `mariadb.sh` script.

```dockerfile
CMD ["/usr/local/bin/mariadb.sh"]
```

- **Startup Script:** Specifies `mariadb.sh` as the script to run when the container starts. This ensures proper initialization of the database.

## Configuration File
By default, MariaDB only allows connections from `localhost`. We need to set bind-address to `0.0.0.0` to allow connections from all networks, and specify the port as `3306`.

The default config file `50-server.cnf` is located in `/etc/mysql/mariadb.conf.d/`.

Modify it as follows:
```conf
[mysqld]
user = mysql
socket = /run/mysqld/mysqld.sock
datadir = /var/lib/mysql
bind-address = 0.0.0.0
port = 3306
```

## mariadb.sh Script
This script handles the initialization and configuration of the MariaDB server.

### Key Responsibilities:

**1. Environment Variable Validation**

Ensures the following environment variables are provided for proper configuration:
- Name of the database to create.
- Name of the user to create.
- Password for the new user.
- Root user password for MariaDB.

**2. Database Initialization**

- Creates a database and user as specified by the environment variables.
- Grants the user permissions on the database.

**3. Root Password Setup**

- Updates the MariaDB root password for enhanced security.

**4. Graceful Restart**

- Stops MariaDB temporarily after initialization to apply changes.
- Restarts MariaDB in the foreground for container compatibility.

### Example Script:
```bash
#!/bin/bash

service mariadb start;

sleep 5; # Wait for mariadb to start properly

mysql -u root "CREATE DATABASE IF NOT EXISTS \`${MYSQL_DATABASE}\`;"
mysql -u root "CREATE USER IF NOT EXISTS \`${MYSQL_USER}\`@'%' IDENTIFIED BY '${MYSQL_PASSWORD}';"
mysql -u root "GRANT ALL PRIVILEGES ON \`${MYSQL_DATABASE}\`.* TO '${MYSQL_USER}'@'%';"
mysql -u root "GRANT ALL PRIVILEGES ON *.* TO 'root'@'%' IDENTIFIED BY '${MYSQL_ROOT_PASSWORD}' WITH GRANT OPTION;"
mysql -u root "FLUSH PRIVILEGES;"

mysqladmin -u root -p"${MYSQL_ROOT_PASSWORD}" shutdown;

exec mysqld_safe;
```

## Testing the Mariadb Container
Follow these steps to verify that your MariaDB container is working correctly:

### Step 1: Build and Run the Container
```bash
docker build -t mariadb-img .
docker run -d --name mariadb-container -p 3306:3306 \
  -e MYSQL_DATABASE=mydb \
  -e MYSQL_USER=myuser \
  -e MYSQL_PASSWORD=mypass \
  -e MYSQL_ROOT_PASSWORD=myrootpass mariadb-img
```

### Step 2: Verify the Container
1. Check Logs
```bash
docker logs mariadb-container
```
- Ensure there are no errors and that MariaDB started successfully.

2. Access the MariaDB Shell
```bash
docker exec -it mariadb-container mysql -u root -p'wp_pass'
```

- Enter the `MYSQL_ROOT_PASSWORD` you specified.

3. Verify the Database and User
```bash
SHOW DATABASES;
SELECT user, host FROM mysql.user;
```

- Confirm that your database and user exist.

## Learn More about Mariadb
Bellow, You will find some useful commands that you need to play with your mariadb container ⬇️

- [MYSQL Tutorial](https://downloads.mysql.com/docs/mysql-tutorial-excerpt-8.0-en.a4.pdf)

💡💡 In your journey working on this project, try to learn these technologies, read a lot of documentation, and get hands-on experience testing your containers. Enjoy every step of the process. Docker is a useful and in-demand technology. Learning it can improve your job prospects. 💡💡

---

# WordPress Container Setup with PHP-FPM
## What is WordPress?
In a nutshell, WordPress is a tool for building websites without coding. Its ease of use and flexibility have made it the leading website creation tool worldwide. In fact, it powers nearly half of the web content, according to recent WordPress statistics.

## What is PHP-FPM?
PHP-FPM (FastCGI Process Manager) is a tool that improves website performance by managing PHP scripts more efficiently. It’s faster than traditional CGI-based methods and capable of handling high traffic loads.

Read this Documentation for better understanding ⬇️
- [FastCGI Process Manager](https://www.php.net/manual/en/install.fpm.php)

## Step 1: The Dockerfile
First, we need to create a `Dockerfile` to define the environment for running WordPress.

Here's the content of the `Dockerfile`:

````dockerfile
FROM debian:bullseye

# Update and upgrade the system, then install necessary dependencies.
# - php7.4: The main PHP runtime.
# - php-fpm: A FastCGI Process Manager for PHP.
# - php-mysql: PHP extension to interact with MySQL.
# - mariadb-client: Allows the container to interact with a MariaDB server.
RUN apt update -y && apt upgrade -y && \
    apt install -y curl php7.4 php-fpm php-mysql mariadb-client && \
    apt clean && rm -rf /var/lib/apt/lists/*

# Copy the PHP-FPM configuration file into the container.
COPY conf/www.conf /etc/php/7.4/fpm/pool.d/www.conf

# Copy the custom WordPress setup script and make it executable.
COPY tools/wordpress.sh /usr/local/bin/wordpress.sh
RUN chmod +x /usr/local/bin/wordpress.sh

# Set the custom script as the default command to run.
CMD ["/usr/local/bin/wordpress.sh"]
````

## Step 2: Configure PHP-FPM

The PHP-FPM configuration file (`www.conf`) ensures the proper functioning of the PHP-FPM service. By default, this file is located at `/etc/php/7.4/fpm/pool.d`. 

Below is the default content:
```ini
[www]
user = www-data
group = www-data
listen = something
listen.owner = www-data
listen.group = www-data
pm = dynamic
pm.max_children = 5
pm.start_servers = 2
pm.min_spare_servers = 1
pm.max_spare_servers = 3
```

### Modify the Configuration
Modify `listen` property to configure PHP-FPM to listen on port `9000`:
```ini
listen = 9000
```

### Copy the Configuration
Create a file named `www.conf` in the `conf/` directory and include the updated content. This file will be copied into the container during the Docker build process.

## Step 3: Custom WordPress Setup Script
We use a custom script named `wordpress.sh` to automate the WordPress setup. Place this file in the `tools/` directory. Here’s the content:

Before starting. Take a look at this Documentation to understand the commands used ⬇️ 
- [WP-CLI Commands](https://developer.wordpress.org/cli/commands/)

1. Create WordPress Directory
```bash
mkdir -p /var/www/wordpress
cd /var/www/wordpress
```
- Creates the directory where WordPress will be installed (`/var/www/wordpress`) and navigates to it.

2. Download and Install WP-CLI
```bash
curl -O https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar
chmod +x wp-cli.phar
mv wp-cli.phar /usr/local/bin/wp
```
- Downloads the WP-CLI (WordPress Command Line Interface).
- Makes it executable and moves it to `/usr/local/bin/wp`, so it can be used globally.

3. Download WordPress Core
```bash
wp core download --allow-root
```
- Downloads the WordPress core files into `/var/www/wordpress`.

4. Move the Sample Configuration File
```bash
mv /var/www/wordpress/wp-config-sample.php /var/www/wordpress/wp-config.php
```
- Renames `wp-config-sample.php` to `wp-config.php`, which is the actual configuration file WordPress uses.

5. Configure the Database Connection
```bash
sed -i "s/define( 'DB_NAME', 'database_name_here' );/define( 'DB_NAME', '${MYSQL_DATABASE}' );/" wp-config.php
sed -i "s/define( 'DB_USER', 'username_here' );/define( 'DB_USER', '${MYSQL_USER}' );/" wp-config.php
sed -i "s/define( 'DB_PASSWORD', 'password_here' );/define( 'DB_PASSWORD', '${MYSQL_PASSWORD}' );/" wp-config.php
sed -i "s/localhost/mariadb/" wp-config.php
```

- Updates wp-config.php to:
    * Use the database name, user, and password from environment variables.
    * Replace `localhost` with `mariadb`, assuming MariaDB is running in a Docker container named `mariadb`.

6. Wait for MariaDB Service
```bash
sleep 10
```
- Pauses the script for 10 seconds to ensure MariaDB is ready to accept connections.

7. Install WordPress
```bash
wp core install \
  --url="${DOMAIN_NAME}" \
  --title="${SITE_TITLE}" \
  --admin_user="${WP_ADMIN_USER}" \
  --admin_password="${WP_ADMIN_PASSWORD}" \
  --admin_email="${WP_ADMIN_EMAIL}" \
  --allow-root
```

- Installs WordPress using WP-CLI with the following:
    * `--url`: The domain name for the WordPress site.
    * `--title`: The site title (e.g., "Inception").
    * `--admin_user`, `--admin_password`, `--admin_email`: Sets up the admin account with provided credentials.

8. Create an Additional Editor User
```bash
wp user create \
    "${WP_USER}" "${WP_USER_EMAIL}" \
    --user_pass="${WP_USER_PASSWORD}" \
    --role=editor \
    --allow-root
```
- Creates another WordPress user with the `editor` role using provided environment variables.

9. Prepare PHP-FPM Runtime Directory
```bash
mkdir -p /run/php
```
- Creates the directory `/run/php` required for PHP-FPM to operate.

10. Start PHP-FPM Service
```bash
php-fpm7.4 -F
```
- Starts the PHP-FPM service in the foreground to handle PHP requests for the WordPress site.

### Summary

This script automates the setup of a WordPress environment by:

- Preparing the installation directory.
- Configuring WordPress using environment variables.
- Installing WordPress with the admin user.
- Creating an additional editor user.
- Starting the PHP-FPM service to serve WordPress.

This ensures the container is ready to handle requests and serve the WordPress application.

### Notes
Ensure the required environment variables (`MYSQL_DATABASE`, `SITE_TITLE`, `MYSQL_USER`, `MYSQL_PASSWORD`, `DOMAIN_NAME`, `WP_ADMIN_USER`, `WP_ADMIN_PASSWORD`, `WP_ADMIN_EMAIL`, etc.) are properly set before running the container.

---

# Docker-Compose Setup
Now that you’ve created and configured individual containers, it’s time to orchestrate them using **Docker Compose**. This step will allow you to manage all your services, networks, and volumes in a single `YAML` file, simplifying deployment and scalability.

## What is Docker Compose?
Docker Compose is a powerful tool that lets you define and manage multi-container applications. Instead of running multiple `docker run` commands, Docker Compose allows you to:

1. Define your services, networks, and volumes in a single YAML file (`docker-compose.yml`).
2. Use simple commands to start, stop, and manage your entire application stack.

Learn more:
- [Docker Compose Documentation](https://docs.docker.com/compose/)

## Setting Up the Docker-Compose File
1. **Install Docker Compose**
Ensure Docker Compose is installed on your machine. You can check by running:

```bash
docker-compose --version
```
If it’s not installed, follow the [Docker Compose installation guide](https://docs.docker.com/compose/install/).

2. **Plan Your Services**
Before writing the `docker-compose.yml` file, identify the services you’ll include. For this project, we need:

- **MariaDB:** Database service for WordPress.
- **NGINX:** Web server for serving WordPress with HTTPS.
- **WordPress:** The application container running WordPress with PHP-FPM.

3. **Define Volumes and Networks**
Plan your storage and container communication:

- **Volumes:** Use persistent storage for the MariaDB database and WordPress files to avoid data loss.
- **Networks:** Create a custom bridge network to enable secure communication between containers.

4. **Create the `docker-compose.yml` File**
Start building your configuration step by step. Below is a detailed breakdown of each section:

## Docker Compose Configuration
### MariaDB Service
MariaDB is the database backend for WordPress. Here’s how to define it:
```yaml
mariadb:
  container_name: mariadb
  networks:
    - inception
  build: ./requirements/mariadb
  image: mariadb:notlatest
  env_file: .env
  volumes:
    - mariadb:/var/lib/mysql
  restart: always
  expose:
    - "3306"  # Internal database communication port
```

### NGINX Service
NGINX will act as the web server, handling HTTPS and reverse proxying PHP requests to WordPress.
```yaml
nginx:
  container_name: nginx
  networks:
    - inception
  depends_on:
    - wordpress
  build: ./requirements/nginx
  image: nginx:notlatest
  env_file: .env
  volumes:
    - wordpress:/var/www/wordpress  # Mount WordPress files
  restart: always
  ports:
    - "443:443"  # Exposing port 443 for HTTPS traffic
```

**Key Points:**
- `depends_on`: Ensures WordPress starts before NGINX.
- `ports`: Maps port `443` on the host to port `443` in the container for HTTPS.

### WordPress Service
The WordPress service runs PHP-FPM, handling dynamic requests.

```yaml
wordpress:
  container_name: wordpress
  networks:
    - inception
  depends_on:
    - mariadb
  build: ./requirements/wordpress
  image: wordpress:notlatest
  env_file: .env
  volumes:
    - wordpress:/var/www/wordpress  # Mount WordPress files
  restart: always
  expose:
    - "9000"  # Internal PHP-FPM port
```

**Key Points:**
- `depends_on`: Ensures MariaDB starts before WordPress.
- `volumes`: Shares WordPress files between the host and container.

### Volumes and Networks
Finally, define the shared storage and networking setup:
```yaml
volumes:
  mariadb:
    driver: local
    driver_opts:
      type: none
      device: /home/abel-mqa/data/mariadb  # Host path for the MariaDB volume
      o: bind
  wordpress:
    driver: local
    driver_opts:
      type: none
      device: /home/abel-mqa/data/wordpress  # Host path for the WordPress files
      o: bind

networks:
  inception:
    driver: bridge
```

**key Points:**
- **Volumes:** Use bind mounts (`device` with `o: bind`) to persist data in specific host directories.
- **Networks:** Use a custom `bridge` network for isolated communication between containers.

### Docker Compose Commands: Quick Reference

Once your `docker-compose.yml` file is ready, use the following commands to manage your stack:

```bash
docker-compose up               # Start all services
docker-compose down             # Stop and remove containers, networks, and volumes
docker-compose logs             # Display logs of running services
docker-compose exec <service>   # Run a command inside a service container
docker-compose ps               # List running containers
```

### Documentation
- [Compose File Reference](https://docs.docker.com/reference/compose-file/)
- [Compose CLI Commands](https://docs.docker.com/reference/cli/docker/compose/)

With this guide, you’re ready to create your docker-compose.yml file, manage your containers effortlessly, and troubleshoot like a pro!

---

# Understanding Networking in Docker
Networking in Docker is a fundamental concept that enables containers to communicate with each other and with external systems. Let’s break down how container networking works and the options available:

## How Docker Networking Works
By default, Docker enables networking for containers, allowing them to make outgoing connections to external networks. However, containers are unaware of the specific network type they are connected to or whether their peers are also Docker workloads. From the container’s perspective, it sees:

- `A network interface with an assigned IP address`.
- `A gateway for outgoing connections`.
- `A routing table`.
- `DNS services for resolving hostnames`.

This abstraction ensures containers can operate independently of the underlying network structure unless explicitly configured otherwise.

Containers can be attached to custom, user-defined networks, allowing them to communicate with each other using their container names or IP addresses. These networks provide greater flexibility and isolation compared to the default settings.

## Docker Network Drivers
Docker uses network drivers to define how containers connect to networks. Each driver provides a unique type of networking functionality:

| **Driver**   | **Description**                                                                                   |
|--------------|---------------------------------------------------------------------------------------------------|
| **bridge**   | The default driver for standalone containers. It creates an isolated network on the Docker host. |
| **host**     | Removes network isolation between the container and the Docker host. Directly shares the host's networking. |
| **none**     | Completely isolates the container from all networks. No external or inter-container communication is possible. |
| **overlay**  | Connects multiple Docker daemons together, allowing containers to communicate across hosts.       |
| **ipvlan**   | Provides full control over IPv4 and IPv6 addressing for containers.                               |
| **macvlan**  | Assigns a unique MAC address to a container, allowing it to appear as a physical device on the network. |

## Example of Custom Networks
In this project, we create a custom **bridge network** named `inception`. This network isolates the containers from external traffic and allows only the containers within this network to communicate securely with each other. For example:

- **MariaDB** can be accessed by the **WordPress** container using its container name (`mariadb`).
- **NGINX** proxies requests to the WordPress container, ensuring secure communication via port `9000`.

By using a user-defined network, we ensure better control, security, and scalability, while also adhering to the project requirement to avoid options like `host` networking or deprecated linking methods.

This setup ensures a well-structured and secure communication environment tailored to our application’s needs.

---

# Finalizing the Project
To complete your WordPress setup with Docker, follow these important steps:

## 1. Configure Your Domain Name

To simplify access to your website, configure your domain name to point to your local IP address. This must follow the format `login.42.fr`, where `login` is your 42 school login.

### Steps:

1. Open the `/etc/hosts` file with elevated privileges:
```bash
sudo nano /etc/hosts
```

2. Add an entry pointing your domain to your local IP:
```plaintext
127.0.0.1 login.42.fr
```
Replace `login` with your own login. For example, if your login is Joe:
```plaintext
127.0.0.1 Joe.42.fr
```

3. Save and exit the file.

**Note:** This ensures that typing `login.42.fr` in your browser redirects to your local WordPress environment.

## 2. Create Folders for Volumes
Docker volumes are used to persist data between container restarts. Create a structured directory to store your project’s data.

### Steps:
1. Create a data folder in your home directory:
```bash
mkdir -p /home/login/data
```
Replace `login` with your 42 login (e.g., Joe):
```bash
mkdir -p /home/Joe/data
```
2. Use this folder as the host directory for your Docker volumes. This ensures all data is stored and accessible outside the container.

## 3. Why Use a Virtual Machine?
Using a virtual machine (VM) is essential for the following reasons:

- **Sudo Permissions for Volumes:** Docker volumes require special permissions to read/write to specific host directories. Without `sudo`, managing these directories (e.g., `/home/login/data`) can lead to permission issues.
- **Separation of Environments:** A VM provides an isolated environment for your project, avoiding interference with your host machine and ensuring compatibility with the required software.

## 4. Add Docker to Sudoers
By default, Docker commands require `sudo`. To simplify usage, add your user to the `docker` group so you can run Docker commands without `sudo`.

### Steps:
1. Add your user to the `docker` group:
```bash
sudo usermod -aG docker $USER
```

2. Log out and log back in to apply the changes.
3. Verify Docker works without `sudo`:
```bash
docker info
```

## 5. Set Up and Run Your Docker Containers
To start your WordPress setup, follow these steps:

### Steps:
1. Navigate to your project directory:
```bash
cd /path/to/your/project
```

2. Build and start your containers:
```bash
docker-compose up -d --build
```

3. Check running containers:
```bash
docker ps
```

## 6. Project Rules and Guidelines
#### Why These Rules Exist:
1. **No `latest` Tag:** Using the `latest` tag for Docker images can lead to version inconsistencies. Always specify explicit versions for stability and reproducibility.

2. **No Hardcoded Passwords:** Hardcoding passwords in Dockerfiles or scripts is a security risk. These files can be accidentally exposed, leading to credential leaks.

3. **Use of Environment Variables:**

- Environment variables enable flexible and secure configuration.
- They prevent sensitive information from being hardcoded.
- They make the setup portable across environments.

4. **Recommended `.env` File:**

- Store all environment variables in a `.env` file at the root of the `srcs` directory.
- This approach centralizes configuration, improves maintainability, and enhances security by keeping sensitive data out of version control.

5. **NGINX as the Only Entry Point:**

- All traffic must be routed through the NGINX container on **port 443** using **TLSv1.2** or **TLSv1.3**.
- This ensures secure communication by encrypting data and protecting against attacks.

## 7. Accessing Your WordPress Website and Admin Dashboard

Once everything is set up, you can access your WordPress website and the admin dashboard as follows:

### Accessing Your Website

1. Open your web browser.
2. Enter your domain name in the address bar:
```uri
https://login.42.fr
```
(Replace `login` with your actual 42 school login.)

3. You should see your WordPress homepage.

### Accessing the WordPress Admin Dashboard

1. In your web browser, navigate to:
```uri
https://login.42.fr/wp-admin
```
2. Enter your admin credentials (created during WordPress installation).
3. Once logged in, you’ll have access to the WordPress dashboard.

### Navigating and Testing Your WordPress Installation

**Basic Navigation:**

- **Posts:** Create new blog posts by going to `Posts > Add New`.
- **Pages:** Add new pages by navigating to `Pages > Add New`.
- **Themes:** Change the site appearance under `Appearance > Themes`.
- **Plugins:** Extend functionality by installing plugins in `Plugins > Add New`.
- **Users:** Manage users under `Users > All Users`.

**Testing Your Setup:**

- Create a test post and publish it.
- Install a basic plugin (e.g., Elementor) and activate it.
- Change the site’s theme and observe the changes.
- Upload a media file (image, PDF) and verify it appears in `Media > Library`.

Final Notes
By following these steps, you’ll have a fully functional and secure WordPress environment. The setup ensures adherence to project requirements while maintaining best practices for security, usability, and maintainability.

---

# Conclusion
If you found this tutorial helpful or learned something new, please show your support by giving it a ⭐ on GitHub! Your feedback encourages me to create more detailed and easy-to-follow guides.

Thank you for reading, and happy coding!
