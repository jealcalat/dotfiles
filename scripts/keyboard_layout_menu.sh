#!/bin/bash

function show_menu() {
    echo "-------------------------------------"
    echo "Keyboard layout menu"
    echo "-------------------------------------"
    echo "Please select an option:"
    echo "1) Español Latam"
    echo "2) Español ES"
    echo "3) English US"
    echo "4) Exit"
}
while true; do
    show_menu
    read -p "Enter your choice: " choice

    case $choice in
        1)
            echo "Cambiando a Español Latam...";
            setxkbmap -layout latam;
            echo "Done.";
            break
            ;;
        2)
            echo "Cambiando a Español ES...";
            setxkbmap -layout es;
            echo "Done.";
            break
            ;;
        3)  
            echo "Cambiando a English US...";
            setxkbmap -layout us;
            echo "Done.";
            break
            ;;
        4) 
            echo "Exiting...";
            exit 0
            ;;
        *)
            echo "Invalid choice. Please try again."
            ;;
    esac  
done