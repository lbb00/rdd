#!/bin/bash

rdd() {
  local path="$1"

  if [[ -z $path ]]; then
    echo -e "\033[31m[rmf] Path is empty\033[0m" >&2
    return
  fi

  if [[ $path != */ ]]; then
    path="${path}/"
  fi

  if [[ $path == "/" ]]; then
    echo -e "\033[31m[rmf] Deleting root directory is dangerous\033[0m" >&2
    return
  fi

  if [[ ! -d $path ]]; then
    echo "rmf: $path is not a directory" >&2
    return
  fi

  echo "Are you sure you want to delete $path?"
  select yn in "Yes" "No"; do
    case $yn in
      Yes ) break;;
      No )
        echo "Cancelled"
        return;;
    esac
  done

  rmf_empty_path="$HOME/rmf_empty/"
  mkdir -p "$rmf_empty_path"
  rsync -av --delete "$rmf_empty_path" "$path"
  rm -rf "$rmf_empty_path"
  rm -rf "$path"

  echo -e "\033[32m[rmf] $path is deleted\033[0m"
}
