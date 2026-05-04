#!/bin/bash

## Change the Name and Links accordingly

# Update the package list and install Nginx
apt update -y
apt install nginx -y

# Enable and start nginx
systemctl enable nginx
systemctl start nginx

# Create portfolio content
cat <<EOF > /var/www/html/index.html
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <title>Pranav Govekar | Portfolio</title>
  <style>
    body {
      font-family: Arial, sans-serif;
      background-color: #f4f4f4;
      text-align: center;
      padding: 50px;
    }
    h1 {
      color: #333;
    }
    p {
      font-size: 18px;
      color: #666;
    }
    a {
      color: #007BFF;
      text-decoration: none;
    }
  </style>
</head>
<body>
  <h1>Hi, I'm Pranav Govekar</h1>
  <p>DevOps · Cloud · Technical Lead</p>
  <p>
    <a href="https://www.linkedin.com/in/pranav-g-921a28110/" target="_blank">LinkedIn</a>
  </p>
</body>
</html>
EOF