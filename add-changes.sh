#!/bin/bash

changes_array=()


checks_for_a_git_repo(){
 if ! git rev-parse --is-inside-work-tree >/dev/null 2>&1; then
   echo "The current directory has not a git repository."
   exit 1
 fi
}

read_changes(){
  local changes=()

  while IFS= read -r line; do
    line="${line#"${line%%[![:space:]]*}"}"  # remove leading whitespace characters
    line="${line%"${line##*[![:space:]]}"}" # remove trailing whitespace characters

    if [[ $line =~ ^(.)(.*)$ ]]; then
      file_path="${BASH_REMATCH[2]}"
      changes+=("$file_path")
    fi
  done < <(git status --porcelain)

  printf '%s\n' "${changes[@]}"
}


checks_for_a_git_repo
git status --porcelain
output=$(read_changes)
