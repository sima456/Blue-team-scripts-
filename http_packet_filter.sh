#!/bin/bash

# Parse command-line arguments
if [[ $# -eq 0 ]] ; then
    echo 'Usage: ./http_packet_filter.sh <pcap file>'
    exit 1
fi
PCAP_FILE=$1

# Set the name of the output file
OUTPUT_FILE="http_packets.txt"

# Run Tshark with the filter expression and write the output to the file
tshark -Y "http contains 11ff :d81111 11 || http contains 11GIF89a11 || http contains 11\x50\x4B\x03\x041111 11 || http contains\xff\xd811 11 11 || http contains 11%PDF11 11 || http contains "\x89\x50\x4E\x47""" -r "$PCAP_FILE" -T fields -e http.request.full_uri > $OUTPUT_FILE

echo "HTTP packets written to $OUTPUT_FILE"
