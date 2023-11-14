#!/bin/bash

# List directories in 'content' that have an 'images' subdirectory
dirs=$(find content -type d -name images)

# Let the user choose a directory
dir=$(echo "${dirs}" | gum choose --no-limit)

# Check if a directory was selected
if [[ -z ${dir} ]]; then
    echo "No directory selected. dir: ${dir}"
    exit 1
fi

# Iterate over the PNG files in the directory
for file in "$dir"/*.jpg; do

    # Extract the base name for the file to use for the .meta file
    base_name=$(basename "$file" .jpg)
    meta_file="${dir}/${base_name}.meta"

    # Check if the .meta file exists
    if [[ -f $meta_file ]]; then
        # Read the existing description
        details=$(<"$meta_file")
    else
        code "${file}"

        # Use gum write to get the description
        details=$(gum write --placeholder "Enter description for $base_name")
        # Save the description to a .meta file
        echo "$details" >"$meta_file"
    fi

    # Open the file in the code editor
    code "$file"

    # Use exiftool to write the metadata, reusing the description
    exiftool -overwrite_original \
        -EXIF:ImageDescription="$details" \
        -iptc:Headline="$details" \
        -iptc:Caption-Abstract="$details" \
        "$file"

    # Output the description to stdout
    echo "Description for $base_name: $details"
done
