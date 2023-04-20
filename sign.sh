#!/bin/bash

# Check if the required parameters have been provided
if [ $# -lt 2 ]; then
  echo "Usage: $0 <file_to_sign> <private_key_file>"
  exit 1
fi

# Input file to be signed
file=$1

# Private key file used to sign the input file
key=$2

# Sign the file
if openssl dgst -sha256 -sign "$key" -out "${file}.signature" "$file"; then
  echo "File signed successfully."
else
  echo "File signing failed."
fi
