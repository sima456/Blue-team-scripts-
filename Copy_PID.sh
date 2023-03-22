#!/bin/bash

# Check if a PID was provided as an argument
if [[ $# -eq 0 ]]; then
    echo "Please provide a PID as an argument."
    exit 1
fi

# Get the process name from the PID
PROCESS_NAME=$(ps -p $1 -o comm=)

# Check if the process exists
if [[ -z "$PROCESS_NAME" ]]; then
    echo "Process with PID $1 does not exist."
    exit 1
fi

# Create a copy of the process
cp /proc/$1/exe /tmp/$PROCESS_NAME-$1

echo "Copied process with PID $1 to /tmp/$PROCESS_NAME-$1"
