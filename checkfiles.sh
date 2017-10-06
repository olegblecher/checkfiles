#!/bin/bash
while read -r FILE; do
  array+=("$FILE")
done

L=${#array[@]}
c=0

for FILE in "${array[@]}"; do
  if [ ! -f "$FILE" ]
  then
    printf "\n\n The file (%s) does not exist\n\n" "$FILE"
  else
    printf '%*s\n' "${COLUMNS:-$(tput cols)}" '' | tr ' ' -
    PERM="$(stat -c "%a" $FILE)"
    printf "\n\nNext file: %s\nPermissions:%s\n\n(1) Read file (2) Go to next file (3) chmod 0 (4) chmod 400 (5) List files with permissions\n\n" "$FILE" "$PERM"
    while true; do
      read -n1 -rs KEY </dev/tty
      case "$KEY" in
        1) less $FILE ;;
        2) printf "\n\nGoing to next file.\n\n"; break ;;
        3) printf "\n\nchmod 0 %s\n\n" "$FILE"; chmod 0 $FILE;;
        4) printf "\n\nchmod 400 %s\n\n" "$FILE"; chmod 400 $FILE ;;
        5) stat -c "%a %n" "${array[@]}" ;;
      esac
    done
  fi
  ((c+=1))
done

printf "\n\n Done!!\n\n" "$FILE"
