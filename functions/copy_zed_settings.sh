#!/usr/bin/env bash

# Copy Zed settings and keymaps to the Mega folder based on OS
copy_zed_settings() {
  local source_dir="$HOME/.config/zed"
  local os_name=$(uname -s)
  local destination_dir="$HOME/Documents/Documents/Desarrollo-de-Software/zed-settings"

  if [[ "$os_name" == "Darwin" ]]; then
    destination_dir="$destination_dir/macos"
  elif [[ "$os_name" == "Linux" ]]; then
    destination_dir="$destination_dir/linux"
  else
    echo "Unsupported OS: $os_name"

    return 1
  fi

  cp "$source_dir/keymap.json" "$destination_dir/"
  cp "$source_dir/settings.json" "$destination_dir/"

  echo "Zed settings and keymap have been copied to $destination_dir"
}
