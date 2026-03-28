# 🚀 Static Website Deployment on AWS EC2 using NGINX and rsync

## 📌 Overview

This project demonstrates how to deploy a static website to an AWS EC2
instance using NGINX as a web server and `rsync` over SSH for secure
file synchronization from a local Ubuntu machine.

------------------------------------------------------------------------

## 🏗️ Architecture

-   Local Machine (Ubuntu)\
    ⟶ SSH + rsync\
-   AWS EC2 Instance (Ubuntu)\
    ⟶ NGINX Web Server\
-   Website is accessed via the EC2 Public IP from a browser

------------------------------------------------------------------------

## ⚙️ Prerequisites

-   AWS account
-   Ubuntu machine (local)
-   SSH client installed
-   Basic knowledge of Linux commands
-   `.pem` key pair downloaded from AWS

------------------------------------------------------------------------

## 🚀 Steps

### 1. Launch EC2 Instance

-   Created an EC2 instance using AWS Management Console
-   Selected:
    -   Ubuntu AMI
    -   Instance type
    -   VPC, subnet, and security group
-   Created and downloaded a **key pair (.pem)** file for SSH
    authentication

------------------------------------------------------------------------

### 2. Configure SSH Access

Set correct permissions for the key file:

``` bash
chmod 400 ~/.ssh/ubuntu-client.pem
```

------------------------------------------------------------------------

### 3. Connect to the EC2 Instance

``` bash
ssh -i ~/.ssh/ubuntu-client.pem ubuntu@<EC2_PUBLIC_IP>
```

------------------------------------------------------------------------

### 4. Install and Start NGINX on EC2

``` bash
sudo apt update
sudo apt install nginx -y
sudo systemctl start nginx
sudo systemctl enable nginx
```

Verify NGINX is running:

``` bash
systemctl status nginx
```

------------------------------------------------------------------------

### 5. Create a Static Website Locally

Example project structure:

    project/
    ├── index.html
    ├── styles.css
    └── images/

------------------------------------------------------------------------

### 6. Deploy Website Using rsync

Transfer files from the local machine to the EC2 instance:

``` bash
rsync -avz -e "ssh -i ~/.ssh/ubuntu-client.pem" ./project/ ubuntu@<EC2_PUBLIC_IP>:/tmp/site
```

Move files into the NGINX web root:

``` bash
ssh -i ~/.ssh/ubuntu-client.pem ubuntu@<EC2_PUBLIC_IP> "sudo rsync -av --delete /tmp/site/ /var/www/html/"
```

------------------------------------------------------------------------

### 7. Access the Website

Open a browser and navigate to:

    http://<EC2_PUBLIC_IP>

You should see the static website served by NGINX.

------------------------------------------------------------------------

## 🔐 Important Notes

-   Ensure the EC2 security group allows:
    -   Port **22 (SSH)**
    -   Port **80 (HTTP)**
-   NGINX default document root:

```{=html}
<!-- -->
```
    /var/www/html/

-   rsync trailing slash behavior:
    -   `project/` → copies only the contents
    -   `project` → copies the directory itself

------------------------------------------------------------------------

## 🧠 Key Concepts Learned

-   AWS EC2 provisioning and configuration
-   SSH authentication using key pairs
-   NGINX installation and service management
-   Secure file transfer using `rsync`
-   Static website deployment workflow
-   Linux system administration basics

------------------------------------------------------------------------

## 📌 Author

Ibrahim Gamal Ibrahim\
DevOps Engineer
