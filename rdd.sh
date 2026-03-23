#!/bin/bash

rdd() {
  local path="$1"

  if [[ -z $path ]]; then
    echo -e "\033[31m[rdd] Path is empty\033[0m" >&2
    return 1
  fi

  if [[ ! -d $path ]]; then
    echo -e "\033[31m[rdd] $path is not a directory\033[0m" >&2
    return 1
  fi

  path="$(realpath "$path")"

  if [[ $path == "/" ]]; then
    echo -e "\033[31m[rdd] Deleting root directory is dangerous\033[0m" >&2
    return 1
  fi

  if [[ $path != */ ]]; then
    path="${path}/"
  fi

  echo "Are you sure you want to delete $path?"
  select yn in "Yes" "No"; do
    case $yn in
      Yes ) break;;
      No )
        echo "Cancelled"
        return 0;;
    esac
  done

  local empty_path
  empty_path="$(mktemp -d)"

  rsync -a --delete "$empty_path/" "$path" || {
    rm -rf "$empty_path"
    echo -e "\033[31m[rdd] rsync failed\033[0m" >&2
    return 1
  }

  rm -rf "$empty_path"
  rm -rf "$path"

  echo -e "\033[32m[rdd] $path is deleted\033[0m"
}
