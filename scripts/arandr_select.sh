#!/bin/bash

# Replace the below path with the path to your scripts directory
SCRIPTS_DIRECTORY="/home/$USER/.local/bin/screenlayout"

function show_menu() {
    echo "Please select a script to run:"
    local i=1
    for script in "$SCRIPTS_DIRECTORY"/*.sh; do
        echo "$i) $(basename "$script")"
        script_list[i]=$script
        ((i++))
    done
    echo "$i) Exit"
}

while true; do
    show_menu
    read -p "Enter your choice: " choice

    if [ "$choice" -eq "$((${#script_list[@]}+1))" ] 2>/dev/null; then
        echo "Exiting..."
        exit 0
    elif [ "$choice" -ge 1 ] 2>/dev/null && [ "$choice" -le "${#script_list[@]}" ] 2>/dev/null; then
        echo "Running the selected script..."
        "${script_list[$choice]}"
        echo "Script execution completed."
        break
    else
        echo "Invalid choice. Please try again."
    fi
done