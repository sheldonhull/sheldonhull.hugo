#!/bin/bash

# Directory containing the files
dir="content/posts/2023/2023-10-31-new-york/images"

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
