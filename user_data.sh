#!/bin/bash

# Update package repositories

apt-get -y update

# Install Git

apt-get -y install git

# Create a temporary shell script for additional setup

# use redirection operator to redirect output from the cat command into a temporary file

# the `<< EOF` here document delimiter, in which a subsequent EOF marks the text that will be input into the cat command

cat > /tmp/subscript.sh << EOF

# START UBUNTU USERSPACE

echo "Setting up NodeJS Environment"

# Set NODE_ENV to 'production' for build process

# When you build NestJS app it needs to be aware of environment variables to do so

export NODE_ENV=production

# Set PATH to include Node.js binaries

export PATH="\$PATH:/home/ubuntu/.nvm/versions/node/v18.13.0/bin"

# Install NVM (Node Version Manager)

# fetch nvm shell script via https with the curl command

# -o- indicates that the output will be displayed in the terminal rather than saved to a file

# and we pipe that output to bash, which executes the shell script

curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.0/install.sh | bash

# Activate NVM

# Set the environment variable for the NVM dir

export NVM_DIR="/home/ubuntu/.nvm"

# if nvm.sh file exists we can dot source it to allow NVM functionality to be available in the current shell session

[ -s "\$NVM_DIR/nvm.sh" ] && . "\$NVM_DIR/nvm.sh"

# Install Node.js version 18.13.0

nvm install 18.13.0

# Set Node.js version 18.13.0 as default

nvm alias default 18.13.0

# Install global npm packages: npm@9.3.0, pm2, and NestJS CLI

npm install -g npm@9.3.0
npm install -g pm2
npm install -g @nestjs/cli@9.1.4

# Clean npm cache

npm cache clean --force

# Clone the GitHub repository to /home/ubuntu/nestjs-api

git clone https://github.com/Jon-Peppinck/nestjs-simple-ip.git /home/ubuntu/nestjs-api

# Navigate to the cloned directory

cd /home/ubuntu/nestjs-api

# Build the NestJS project

npm install
npm run build

# Set ownership and permissions for the 'dist' folder

chown -R ubuntu:ubuntu /home/ubuntu/nestjs-api/dist
chmod -R 755 /home/ubuntu/nestjs-api/dist

# Start the Node.js application using pm2

pm2 start ./dist/main.js

# Save the current pm2 process list for automatic restart

pm2 save
EOF

# Set ownership and permissions for the temporary shell script

chown ubuntu:ubuntu /tmp/subscript.sh && chmod a+x /tmp/subscript.sh

# Execute the script as the 'ubuntu' user

su - ubuntu -c "/tmp/subscript.sh"