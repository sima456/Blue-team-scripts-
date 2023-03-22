#!/bin/bash

# Get the file name of the capture file
read -p "Enter the name of the capture file: " FILE

# Check if the file exists
if [ ! -f "$FILE" ]; then
  echo "File does not exist!"
  exit 1
fi

# Ask the user for the number of top results to display
read -p "Enter the number of top results to display: " NUM_RESULTS

# Extract unique source and destination IP addresses and sort by frequency
echo "Top $NUM_RESULTS connections:"
tcpdump -tnr $FILE | awk -F '. ' '{print $2 "." $3 " -> " $4}' | sort | uniq -c | sort -rn | head -n $NUM_RESULTS

# Display a histogram of traffic by protocol
echo "Traffic by protocol:"
tcpdump -tnr $FILE | awk '{print $2}' | awk -F '.' '{print $1}' | sort | uniq -c | awk '{printf("%s %s\n",$2,$1)}' | gnuplot -p -e "set boxwidth 0.5; set style fill solid; plot '<cat' using 2:xtic(1) with boxes notitle"

# Show top talkers by number of packets and bytes
echo "Top talkers by packets:"
tcpdump -tnr $FILE | awk '{print $3}' | sort | uniq -c | sort -rn | head -n 10
echo "Top talkers by bytes:"
tcpdump -tnr $FILE | awk '{print $3, $NF}' | sed 's/\[//g;s/\]//g' | awk '{sum[$1] += $2} END {for (i in sum) print sum[i], i}' | sort -rn | head -n 10
