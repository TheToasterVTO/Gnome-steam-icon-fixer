#!/bin/bash

# Adds "StartupWMClass=steam_app_<id>" to all .desktop files located in the DIR specified (default is the directory the script currently is in) 
# to resolve missing missing game icons on Steam games in GNOME applications overview and task switcher.
# This is a modified verison of https://gitlab.com/-/snippets/3763640 to allow automatic execution.



DIR="."
i=0
filelist=()

# Loop through files
for file in "$DIR"/*; do
    if [ -f "$file" ]; then
        file_list+=("$(basename "$file")")
    fi
done

for file in "${file_list[@]}"; do

    if [ "$file" != "steam_icon_fixer.sh" ]; then

        GAME_ID=$(grep '^Exec=' "$file" | grep -oP 'steam://rungameid/\K[0-9]+')

        if [[ -z "$GAME_ID" ]]; then
            echo "Game ID not found in $file"
            continue
        fi

        if grep -q '^StartupWMClass=' "$file"; then
            continue
        fi

        echo "StartupWMClass=steam_app_$GAME_ID" >> "$file"
        let i+=1
    fi
    
done
echo "Complete. Added $i icons."
exit 1
