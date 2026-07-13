#!/bin/bash

set -x

cd 

touch .profile

set +e
sudo apt-get update -y
sudo apt-get upgrade -y
set -e

sudo apt-get install lsb-release wget gnupg -y

sudo apt-get install wget -y
sudo wget https://packages.osrfoundation.org/gazebo.gpg -O /usr/share/keyrings/pkgs-osrf-archive-keyring.gpg
echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/pkgs-osrf-archive-keyring.gpg] http://packages.osrfoundation.org/gazebo/ubuntu-stable $(lsb_release -cs) main" | sudo tee /etc/apt/sources.list.d/gazebo-stable.list > /dev/null
set +e
sudo apt-get update -y
set -e

sudo apt-get install gz-harmonic -y


cd
sudo apt-get install git python3-pip -y
git clone --depth 1 --branch release/v1.17 https://github.com/PX4/PX4-Autopilot.git --recursive
cd PX4-Autopilot/

bash ./Tools/setup/ubuntu.sh --no-sim-tools
make px4_sitl


sudo apt install python3-colcon-clean python3-opencv -y


sudo apt autoremove -y


