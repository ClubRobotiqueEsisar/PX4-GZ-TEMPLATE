#!/bin/bash
SCRIPT_DIR="$(dirname "$(realpath "$0")")"

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


# ---------- Selecteur de branche PX4 ---------- #

# Sélection du dépôt
repo="https://github.com/PX4/PX4-Autopilot.git"
folder="PX4-Autopilot"
PX4_DIR="$(pwd)/$folder"

# git clone
cd
git clone -b release/1.17 "$repo" --recursive


# ---------- Fin du Selecteur de branche PX4 ---------- #

cd $PX4_DIR/
cp -r "$SCRIPT_DIR/PX4-Autopilot_PATCH/Tools" "$PX4_DIR/"

bash $PX4_DIR/Tools/setup/ubuntu.sh --no-sim-tools
make px4_sitl


sudo apt install python3-colcon-clean python3-opencv -y


sudo apt autoremove -y


