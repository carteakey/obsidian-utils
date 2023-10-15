import os
import re

def replace_latex_format(content):
    # Define the patterns to be replaced
    patterns = {
        r"\\\[ ": "$$",
        r" \\\]": "$$",
        r"\\\(": "$",
        r" \\\)": "$"
    }

    # Apply replacements
    for pattern, replacement in patterns.items():
        content = re.sub(pattern, replacement, content)
    
    return content

def process_files(directory="."):
    changed_files = []

    for root, dirs, files in os.walk(directory):
        for file in files:
            if file.endswith(".md"):
                filepath = os.path.join(root, file)
                with open(filepath, 'r', encoding='utf-8') as f:
                    content = f.read()
                    new_content = replace_latex_format(content)

                # If changes were made, save the new content and add to changed files list
                if new_content != content:
                    with open(filepath, 'w', encoding='utf-8') as f:
                        f.write(new_content)
                    changed_files.append(filepath)

    return changed_files

if __name__ == "__main__":
    modified = process_files()
    if modified:
        print("Modified the following files:")
        for file in modified:
            print(file)
    else:
        print("No files were modified.")

