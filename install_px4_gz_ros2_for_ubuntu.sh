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


# ---------- PX4 installation ---------- #
repo="git@github.com:PX4/PX4-Autopilot.git"
folder="PX4-Autopilot"
PX4_DIR="$(pwd)/$folder"


# ---------- End PX4 installation ---------- #

# Vérification que le dossier n'existe déja pas
if [ -d "$folder" ]; then
    while true; do
        read -p "Le dossier $PX4_DIR existe déja. Voulez-vous le supprimer et choisir la version appropriée ? (Y/N) : " answer

        case "${answer,,}" in
            y)
                rm -rf "$folder"
                echo "Dossier supprimé."
				# Clone
				git clone "$repo" "$folder"

				cd "$folder"

				echo "Dépôt cloné dans : $(pwd)"

				# Met à jour les branches distantes
				git fetch --all --prune

				# Sélection d'une branche
				branch=$(git branch -a --color=never |
					sed 's/^[* ]*//' |
					sed 's#remotes/origin/##' |
					sort -u |
					fzf --prompt="Choisir une branche > ")

				if [ -z "$branch" ]; then
					echo "Aucune branche sélectionnée."
					exit 0
				fi

				echo "Checkout de la branche : $branch"

				git checkout "$branch"

				echo "Branche active : $(git branch --show-current)"

				# Update git submodules
				git submodule update --init --recursive

                break
                ;;
            n)
				cd "$folder"
				echo "Branche active : $(git branch --show-current)"
                break
                ;;
            *)
                echo "Veuillez répondre par Y ou N."
                ;;
        esac
    done
fi


cp -r "$SCRIPT_DIR/PX4-Autopilot_PATCH/Tools" "$PX4_DIR/"

bash $PX4_DIR/Tools/setup/ubuntu.sh --no-sim-tools
make px4_sitl


sudo apt install python3-colcon-clean python3-opencv -y


sudo apt autoremove -y


