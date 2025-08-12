#!/usr/bin/env bash

# Copy macos Zed settings and keymaps to the Mega folder
copy_zed_macos_settings() {
  local source_dir="$HOME/.config/zed"
  local destination_dir="$HOME/Documents/Documents/Desarrollo-de-Software/zed-settings/macos"

  cp "$source_dir/keymap.json" "$destination_dir/"
  cp "$source_dir/settings.json" "$destination_dir/"

  echo "Zed settings and keymap have been copied to $destination_dir"
}
