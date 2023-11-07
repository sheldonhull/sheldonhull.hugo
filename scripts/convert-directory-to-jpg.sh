#!/bin/bash
directory="$HOME/Downloads/convertme"

# Define the directory containing the original files and the output directory for JPEG files
original_directory="$directory"
jpeg_directory="$directory/jpeg_directory"

# Maximum width for full-screen web display
max_width=1920

# JPEG quality setting
quality=85

# ANSI color codes
RED='\033[0;31m'
GREEN='\033[0;32m'
NC='\033[0m' # No Color

# Emoji symbols
SUCCESS_EMOJI="💚"
FAILURE_EMOJI="💔"

# Create the directory for the converted JPEG files if it doesn't exist
mkdir -p "$jpeg_directory"

# Function to convert bytes to megabytes and format the output
format_size() {
    local bytes=$1
    echo "scale=2; $bytes / 1024 / 1024" | bc | awk '{printf "%.2fMB", $0}'
}

# Loop through each file in the original directory
for original_file in "$original_directory"/*.*; do
    # Extract the base name without the extension
    base_name=$(basename "$original_file")
    base_name_no_ext="${base_name%.*}"

    # Define the new JPEG filename
    jpeg_file="$jpeg_directory/${base_name_no_ext}.jpg"

    # Get the original file size in MB and format it
    original_size_bytes=$(stat -f%z "$original_file")
    original_size_formatted=$(format_size $original_size_bytes)

    # Convert the file to optimized JPEG format and resize it
    convert_command="convert \"$original_file\" -resize \"${max_width}x${max_width}>\" -strip -interlace Plane -quality $quality -colorspace sRGB \"$jpeg_file\""
    if eval $convert_command; then
        # Get the converted file size in MB and format it
        converted_size_bytes=$(stat -f%z "$jpeg_file")
        converted_size_formatted=$(format_size $converted_size_bytes)

        # Calculate the percentage savings
        savings=$(echo "scale=2; 100 - ($converted_size_bytes / $original_size_bytes) * 100" | bc)

        echo -e "${GREEN}Conversion to JPEG successful. Size: ${original_size_formatted} - ${converted_size_formatted} (${savings}%) ${SUCCESS_EMOJI}${NC}"
    else
        echo -e "${RED}Conversion to JPEG failed ${FAILURE_EMOJI}${NC}"
        echo -e "Command that failed: $convert_command"
    fi
done
