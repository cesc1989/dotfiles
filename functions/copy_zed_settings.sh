#!/usr/bin/env bash

# Copy Zed settings and keymaps to a specified directory
copy_zed_settings() {
  local source_dir="$HOME/.config/zed"
  local destination_dir="$HOME/Documents/Documents-2024-10-18/Desarrollo de Software/zed-settings"

  cp "$source_dir/keymap.json" "$destination_dir/"
  cp "$source_dir/settings.json" "$destination_dir/"

  echo "Zed settings and keymap have been copied to $destination_dir"
}
