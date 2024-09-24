rdd() {
  if [[ -z $1 ]]; then
    echo -e "\033[31m[rmf] Path is empty\033[0m"
    return
  fi

  if [[ $1 != */ ]]; then
    1="${1}/"
  fi

  if [[ $1 == "/" ]]; then
    echo -e "\033[31m[rmf] Deleting root directory is dangerous\033[0m"
    return
  fi

  if [[ ! -d $1 ]]; then
    echo "rmf: $1 is not a directory"
    return
  fi

  echo "Are you sure you want to delete $1?"
  select yn in "Yes" "No"; do
    case $yn in
      Yes )
        break;;
      No )
        echo "Cancelled"
        return;;
    esac
  done

  rmf_empty_path="$HOME/rmf_empty/"
  mkdir -p "$rmf_empty_path"
  rsync -av --delete "$rmf_empty_path" "$1"
  rm -rf "$rmf_empty_path"
  rm -rf "$1"

  echo -e "\033[32m[rmf] $1 is deleted\033[0m"
}
