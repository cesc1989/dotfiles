#!/bin/bash

# Create a git worktree outside the current directory.
# After creating the worktree, it'll copy files .nvmrc and .env if they exist.
#
# Usage: create_git_worktree <folder_name> <branch_name>
#
# Example in Edge: create_git_worktree sftptodrive edg_2048_sftp_to_gdrive
create_git_worktree() {
  local folder_name="$1"
  local branch_name="$2"
  local current_dir=$(pwd)
  local parent_dir=$(dirname "$current_dir")
  local worktree_path="$parent_dir/$folder_name"

  if [[ -z "$folder_name" || -z "$branch_name" ]]; then
    echo "Usage: create_git_worktree <folder_name> <branch_name>"
    echo ""
    echo "Create a git worktree outside the current directory."
    echo "After creating the worktree, it'll copy files .nvmrc and .env if they exist."
    echo ""
    echo "Arguments:"
    echo "  folder_name   Name of the folder to create for the worktree"
    echo "  branch_name   Name of the branch to checkout in the worktree"
    echo ""
    echo "Example:"
    echo "  create_git_worktree sftptodrive edg_2048_sftp_to_gdrive"

    return 1
  fi

  if [[ -d "$worktree_path" ]]; then
    echo "Error: Directory '$worktree_path' already exists"

    return 1
  fi

  echo "Creating worktree '$branch_name' in '$worktree_path'"
  git worktree add "$worktree_path" "$branch_name"

  if [[ $? -eq 0 ]]; then
    echo "Worktree created successfully at: $worktree_path"

    if [[ -f ".nvmrc" ]]; then
      cp ".nvmrc" "$worktree_path/"
      echo "Copied .nvmrc to worktree"
    fi

    if [[ -f ".env" ]]; then
      cp ".env" "$worktree_path/"
      echo "Copied .env to worktree"
    fi

    if [[ -f "test_models.rb" ]]; then
      cp "test_models.rb" "$worktree_path/"
      echo "Copied test_models to worktree"
    fi

    echo "You can navigate to it with: cd $worktree_path"
  else
    echo "Error: Failed to create worktree"

    return 1
  fi
}
