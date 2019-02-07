#!/bin/bash

safe_type() {
    type $1 > /dev/null 2>&1
}

check_curl() {
    if ! safe_type curl ; then
        echo "The 'curl' utility is required. Please install with your package manager."
        exit 100
    fi
}
check_curl

HOMEBIN="$HOME/bin"
if [ -d "$HOMEBIN" ] && [[ ":$PATH:" == *":$HOME/bin:"* ]]; then
    DEFAULT_FOLDER=$HOMEBIN
    DEFAULT_PROMPT=" (default $HOMEBIN)"
fi    

while [ -z "$SELECTED_FOLDER" ]; do
    echo "Where would you like to install the alpha command?"
    read -e -p "Folder name$DEFAULT_PROMPT? " FOLDER
    SELECTED_FOLDER=${FOLDER:-$DEFAULT_FOLDER}
    SELECTED_FOLDER=${SELECTED_FOLDER%/}

    if [ ! -d "$SELECTED_FOLDER" ]; then
        echo "The selected folder does not exist. Please create the folder in run again."
        exit 1;
    fi
    if [ ! -w "$SELECTED_FOLDER" ]; then
        echo "The selected folder is not writable. Please modify the permissions or choose another folder."
        exit 1;
    fi
done

if [[ ":$PATH:" != *":$SELECTED_FOLDER:"* ]]; then
    echo "Warning: $SELECTED_FOLDER is not in path."
    echo "To execute the command, you'll need to run using the full path:"
    echo "-->  $SELECTED_FOLDER/alpha login"
    echo
fi

ALPHA_DEST=$SELECTED_FOLDER/alpha

if [ -f "$ALPHA_DEST" ]; then
    echo "Found existing installation at $ALPHA_DEST. Will update."
fi 

echo "Fetching alpha command"
if curl -o "$ALPHA_DEST" "https://raw.githubusercontent.com/Alpha-Drive/alpha-command/master/alpha"; then
    chmod +x "$ALPHA_DEST"
    if safe_type alpha ; then
        echo "The alpha command is ready to run."
    else
        echo "Something went wrong with the download."
    fi
else
    echo "Curl of command file failed."
fi

