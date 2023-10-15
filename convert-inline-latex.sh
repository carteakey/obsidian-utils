#!/bin/bash

# Function to process each .md file
process_file() {
    local file="$1"
    
    # Use sed to make replacements
    sed -i.bak -E -e 's/\\\[ /$$/g' \
                -e 's/ \\\]/$$/g' \
                -e 's/\\\(/$/g' \
                -e 's/ \\\)/$/g' "$file"

    # If the file is different from its backup, then it was modified
    if ! cmp --silent "$file" "$file.bak"; then
        echo "Modified: $file"
    fi

    # Remove the backup
    rm "$file.bak"
}

export -f process_file

# Use find to get all .md files and process them
find . -type f -name "*.md" -exec bash -c 'process_file "$0"' {} \;

