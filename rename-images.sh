#!/bin/bash

MODE="$1"
TEMP_MD="/var/tmp/obsidian-rename-image.$$"
IMAGES_PATH="Attachments/"

[[ "$MODE" != "PREVIEW" && "$MODE" != "RENAME" ]] && echo "Usage: $(basename $0) PREVIEW|RENAME \nExample: $(basename $0) PREVIEW" && exit 1

find . -name "*.md" > "$TEMP_MD"

ls -1 "${IMAGES_PATH}"*.{jpg,png,gif} 2>/dev/null | sort -n | while read CURRENT_IMAGE ; do
  # For each image ...
  EXT="${CURRENT_IMAGE##*.}"
  CURRENT_IMAGE_BASENAME=$(basename "$CURRENT_IMAGE")
  
  echo "> Image [$CURRENT_IMAGE_BASENAME]"
  
  DEST_FILENAME=$(cat /dev/urandom | tr -dc 'a-zA-Z0-9' | fold -w 10 | head -n 1)
  
  OK=1
  while [[ "$OK" -ne 0 ]] ; do
    TARGET_IMAGE="${IMAGES_PATH}${DEST_FILENAME}.${EXT}"
    OK=0
    [[ -f "${TARGET_IMAGE}" ]] && OK=1
  done
  
  # Rename image  
  case "$MODE" in
    "PREVIEW")
      echo "  - Renaming image file [${CURRENT_IMAGE}] to [${TARGET_IMAGE}]"
      ;;
    "RENAME")
      mv "${CURRENT_IMAGE}" "${TARGET_IMAGE}"
      ;;
  esac

  # Markdown files
  cat "$TEMP_MD" | while read MD_FILE ; do
    NB_OCC_IN_MD_FILE=$(grep "$CURRENT_IMAGE_BASENAME" "${MD_FILE}" | wc -l)
    if [[ "${NB_OCC_IN_MD_FILE}" -ne 0 ]] ; then
      case "$MODE" in
        "PREVIEW")
          echo "  - Rewriting markdown in [$MD_FILE] : '![[$CURRENT_IMAGE_BASENAME]]' to '![[$TARGET_IMAGE]]'"
          ;;
        "RENAME")
          sed -i -e "s&!\[\[$CURRENT_IMAGE_BASENAME\]\]&!\[\[$TARGET_IMAGE\]\]&g" "${MD_FILE}"
          ;;
      esac
    fi 
  done
  
  echo ""
  
done

rm -f "$TEMP_MD" >/dev/null 2>&1 
