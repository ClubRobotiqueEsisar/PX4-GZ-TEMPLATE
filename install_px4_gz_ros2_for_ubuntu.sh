#!/bin/bash
SCRIPT_DIR="$(dirname "$(realpath "$0")")"
PX4_DIR="$SCRIPT_DIR/../PX4-Autopilot"

set +e
sudo apt-get update -y
sudo apt-get upgrade -y
set -e

sudo apt-get install lsb-release wget gnupg -y

# ---------- Gazebo Install ---------- #

sudo apt-get install wget -y
sudo wget https://packages.osrfoundation.org/gazebo.gpg -O /usr/share/keyrings/pkgs-osrf-archive-keyring.gpg
echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/pkgs-osrf-archive-keyring.gpg] http://packages.osrfoundation.org/gazebo/ubuntu-stable $(lsb_release -cs) main" | sudo tee /etc/apt/sources.list.d/gazebo-stable.list > /dev/null
set +e
sudo apt-get update -y
set -e

sudo apt-get install gz-harmonic -y

# ---------- END Gazebo Install ---------- #


# ---------- PX4 Install ---------- #
cd "$SCRIPT_DIR/.."
git clone https://github.com/PX4/PX4-Autopilot.git --recursive
cd PX4-Autopilot

git checkout release/1.17


# ---------- END PX4 Install ---------- #


# ---------- PX4 Setup ---------- #

sudo apt-get install python3-pip -y


cp -r "$SCRIPT_DIR/PX4-Autopilot_PATCH/Tools" "$PX4_DIR/"

bash $PX4_DIR/Tools/setup/ubuntu.sh --no-sim-tools
make px4_sitl


# ---------- END PX4 Setup ---------- #


sudo apt autoremove -y


