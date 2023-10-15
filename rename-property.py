import os
import re

def rename_property(file_path, old_property, new_property):
    with open(file_path, 'r', encoding='utf-8') as file:
        content = file.read()

    # Use a regular expression to find and replace the property name
    updated_content = re.sub(fr'(?<=^|\n){old_property}:', f'{new_property}:', content)

    # Check if the content was actually changed
    if updated_content != content:
        # Write the updated content back to the file
        with open(file_path, 'w', encoding='utf-8') as file:
            file.write(updated_content)

def rename_property_in_vault(vault_path, old_property, new_property):
    # Walk through all files in the vault
    for foldername, subfolders, filenames in os.walk(vault_path):
        for filename in filenames:
            if filename.endswith('.md'):  # Process only Markdown files
                file_path = os.path.join(foldername, filename)

                # Check if the property exists in the file before attempting to rename
                with open(file_path, 'r', encoding='utf-8') as file:
                    content = file.read()
                    if re.search(fr'(?<=^|\n){old_property}:', content):
                        rename_property(file_path, old_property, new_property)

if __name__ == "__main__":
    # Replace these values with your actual property names
    old_property_name = "old_property"
    new_property_name = "new_property"

    # Replace this with the path to your Obsidian vault
    obsidian_vault_path = "/path/to/your/obsidian/vault"

    # Rename the property in files that contain the property
    rename_property_in_vault(obsidian_vault_path, old_property_name, new_property_name)