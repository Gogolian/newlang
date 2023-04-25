#!/bin/bash

# a script to join all files in existing codebase to one large file

output_file="joined_files.txt"
script_name="join_files.sh"

function join_files() {
  local dir="$1"
  local relative_path="${2:-.}"

  for entry in "$dir"/*; do
    if [[ -d "$entry" ]]; then
      join_files "$entry" "$relative_path/$(basename "$entry")"
    elif [[ -f "$entry" && "$(basename "$entry")" != "$script_name" && "$(basename "$entry")" != "$output_file" ]]; then
      echo -e "// $relative_path/$(basename "$entry")\n" >> "$output_file"
      cat "$entry" >> "$output_file"
      echo -e "\n" >> "$output_file"
    fi
  done
}

join_files "$(pwd)"


