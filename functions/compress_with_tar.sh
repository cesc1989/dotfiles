#!/bin/bash

# Compress files or directories using tar with gzip compression.
#
# Usage: compress_with_tar <source> <destination>
#
# Arguments:
#   source      File or directory to compress
#   destination Path for the compressed archive (will have .tar.gz added if not present)
#
# Examples:
#   compress_with_tar my_folder my_archive.tar.gz
#   compress_with_tar file.txt backup.tar.gz
compress_with_tar() {
  local source="$1"
  local destination="$2"

  if [[ -z "$source" || -z "$destination" ]]; then
    echo "Error: Missing required arguments"
    echo ""
    echo "Usage: compress_with_tar <source> <destination>"
    echo ""
    echo "Arguments:"
    echo "  source      File or directory to compress"
    #   destination Path for the compressed archive (will have .tar.gz added if not present)
    echo ""
    echo "Examples:"
    echo "  compress_with_tar my_folder my_archive.tar.gz"
    echo "  compress_with_tar file.txt backup.tar.gz"

    return 1
  fi

  if [[ ! -e "$source" ]]; then
    echo "Error: Source '$source' does not exist"
    return 1
  fi

  # Add .tar.gz extension if not present
  if [[ ! "$destination" =~ \.tar\.gz$ ]]; then
    destination="${destination}.tar.gz"
  fi

  echo "Compressing '$source' to '$destination'..."
  tar czf "$destination" "$source"

  if [[ $? -eq 0 ]]; then
    echo "Successfully created archive: $destination"
  else
    echo "Error: Failed to create archive"
    return 1
  fi
}
