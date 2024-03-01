#!/bin/bash

# get base path of script
BASE_PATH="$(dirname -- "${BASH_SOURCE[0]}")" # relative
BASE_PATH="$(cd -- "$BASE_PATH" && pwd)"      # absolutized and normalized
if [[ -z "$BASE_PATH" ]] ; then
    # error; for some reason, the path is not accessible
    exit 1  # fail
fi


# TODO: auto-install


# auto config move
for source_file in "$BASE_PATH/configs/"*; do

    # get raw destination path trimming whitespaces
    destination_file=$(head -n 5 $source_file | grep -Po '(?<=#file_dst:).+' | sed -e 's/^[[:space:]]*//' -e 's/[[:space:]]*\n*$//')

    if [[ -n $destination_file ]]; then
        case $destination_file in
            "~/"*)
                # the path is relative to the user's home
                # substitute the starting "~/" with the contents of ${HOME}
                full_destination_path="$HOME/${destination_file#"~/"}"
            ;;

            "/"*)
                # the path is absolute
                full_destination_path=$destination_file
            ;;

            *)
                # here assuming the path is relative to the folder where the script is running
                full_destination_path="$BASE_PATH/$destination_file"
            ;;
        esac

        if [[ -n $full_destination_path ]]; then
            cp $source_file $full_destination_path
        fi
    fi
done
