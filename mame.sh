#!/usr/bin/env bash

# Display cool ASCII logo
echo " _______  _______  _______  _______  _______ "
echo "(  ____ \(       )(  ___  )(       )(  ____ \\"
echo "| (    \/| () () || (   ) || () () || (    \/"
echo "| (_____ | || || || (___) || || || || (__    "
echo "(_____  )| |(_)| ||  ___  || |(_)| ||  __)   "
echo "      ) || |   | || (   ) || |   | || (      "
echo "/\____) || )   ( || )   ( || )   ( || (____/\\"
echo "\_______)|/     \||/     \||/     \|(_______/"

# Check if the user is root
if [[ $(id -u) -ne 0 ]]
then
    echo "Please run as root"
    exit 1
fi

# Check Linux distribution and install dependencies
if [[ -f /etc/lsb-release ]]
then
    # Ubuntu
    apt-get update
    apt-get install default-jre wget
elif [[ -f /etc/redhat-release ]]
then
    # CentOS
    yum update
    yum install java-1.8.0-openjdk wget
elif [[ -f /etc/debian_version ]]
then
    # Debian
    apt-get update
    apt-get install default-jre wget
elif [[ -f /etc/fedora-release ]]
then
    # Fedora
    dnf update
    dnf install java-1.8.0-openjdk wget
else
    # Unsupported Linux distribution
    echo "Error: unsupported Linux distribution"
    exit 1
fi

# Display menu and ask user for option
echo "1. Install and setup Minecraft server"
echo "2. Remove Minecraft server"
read -p "Enter an option (1 or 2): " option

if [[ $option -eq 1 ]]
then
    # Download minecraft server
    wget https://launcher.mojang.com/v1/objects/bb2b6b1aefcd70dfd1892149ac3a215f6c636b07/server.jar

    # Start server for the first time to generate EULA
    java -Xmx1024M -Xms1024M -jar server.jar nogui

    # Ask user for server name
    read -rp "Enter a name for your server: " server_name

    # Set server name in server.properties file
    sed -i "s/^server-name=.*/server-name=$server_name/" server.properties

    # Ask user for server ip
    read -rp "Enter the ip address for your server: " server_ip

    # Set server ip in server.properties file
    sed -i "s/^server-ip=.*/server-ip=$server_ip/" server.properties

    # Set eula to true in eula.txt file
    sed -i 's/^eula=.*/eula=true/' eula.txt

    # Start the minecraft server
    java -Xmx1024M -Xms1024M -jar server.jar nogui
elif [[ $option -eq 2 ]]
then
    # Stop the minecraft server
pkill -f "java -Xmx1024M -Xms1024M -jar server.jar"

# Remove minecraft server files
rm -f server.jar
rm -f server.properties
rm -f eula.txt

# Remove minecraft server logs
rm -rf logs/

echo "Minecraft server removed successfully"

fi
