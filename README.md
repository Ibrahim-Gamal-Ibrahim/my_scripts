# 🚀 Static Website Deployment on AWS EC2 using NGINX and rsync

## 📌 Overview

This project demonstrates how to deploy a static website to an AWS EC2 instance using NGINX as a web server and `rsync` over SSH for file synchronization from a local Ubuntu machine.

---

## 🏗️ Architecture

- Local Machine (Ubuntu)
  ⟶ SSH + rsync  
- AWS EC2 Instance (Ubuntu)
  ⟶ NGINX Web Server  
- Public IP used to access the deployed website via browser

---

## ⚙️ Prerequisites

- AWS Account
- Ubuntu machine (local)
- SSH client installed
- Basic knowledge of Linux commands
- `.pem` key file downloaded from AWS

---

## 🚀 Steps

### 1. Launch EC2 Instance

- Created an EC2 instance via AWS Management Console
- Selected:
  - Ubuntu AMI
  - Instance type
  - VPC, subnet, and security group
- Created and downloaded a **key pair (.pem)** for SSH access

---

### 2. Configure SSH Access

Set correct permissions for the key file:

```bash
chmod 400 ubuntu-client.pem

Connect to the EC2 instance:

ssh -i ~/.ssh/ubuntu-client.pem ubuntu@<EC2_PUBLIC_IP>
3. Install and Start NGINX on EC2
sudo apt update
sudo apt install nginx -y
sudo systemctl start nginx
sudo systemctl enable nginx

Verify NGINX is running:

systemctl status nginx
4. Create a Static Website Locally

Example project structure:

project/
├── index.html
├── styles.css
└── images/
5. Deploy Website Using rsync

Transfer files from local machine to EC2:

rsync -avz -e "ssh -i ~/.ssh/ubuntu-client.pem" ./project/ ubuntu@<EC2_PUBLIC_IP>:/tmp/site

Move files into NGINX web root:

ssh -i ~/.ssh/ubuntu-client.pem ubuntu@<EC2_PUBLIC_IP> "sudo rsync -av --delete /tmp/site/ /var/www/html/"
6. Access the Website

Open a browser and navigate to:

http://<EC2_PUBLIC_IP>

You should see the deployed static website served by NGINX.

🔐 Important Notes
Ensure the EC2 security group allows:
Port 22 (SSH)
Port 80 (HTTP)
NGINX default document root:
/var/www/html/
The trailing slash in rsync:
project/ → copies contents
project → copies the directory itself
🧠 Key Concepts Learned
AWS EC2 provisioning and configuration
SSH authentication using key pairs
NGINX installation and service management
Secure file transfer using rsync
Static website deployment workflow
Linux system administration basics
📌 Author

Ibrahim Gamal Ibrahim
DevOps Engineer
