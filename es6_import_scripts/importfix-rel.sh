#!/bin/bash
: relpath A B
# Calculate relative path from A to B, returns true on success
# Example: ln -s "$(relpath "$A" "$B")" "$B"
relpath() {
    local X Y A
    # We can create dangling softlinks
    X="$(readlink -m -- "$1")" || return
    Y="$(readlink -m -- "$2")" || return
    X="${X%/}/"
    A=""
    while   Y="${Y%/*}"
            [ ".${X#"$Y"/}" = ".$X" ]
    do
            A="../$A"
    done
    X="$A${X#"$Y"/}"
    X="${X%/}"
    echo "${X:-.}"
}



ADD_IMPORT=$1

printf "%-45s | %-45s | %-45s\n" "File" "Import" "Status"
printf "%-45s | %-45s | %-45s\n" "" "" ""

grep -rlP "export" --exclude-dir modules/ . |  while read -r EXPORT_FILE; 
do 
    CLASS=$(grep -oP --include "*.js" '(?<=^export default class )(\w*)\b' $EXPORT_FILE); 

    if [ ! -z $CLASS ]; then
        grep -rlP "new $CLASS\W|\b$CLASS\.|\bextends $CLASS\b" "$HOME/development/trim5/public/" --exclude-dir "$HOME/development/trim5/public/modules" | sort | while read IMPORT_FILE;   
        do 
            IMPORT_REL_PATH="./$(relpath "$EXPORT_FILE" "$IMPORT_FILE")";
            replacement="import ${CLASS} from '${IMPORT_REL_PATH}';\n"
            ALREADY_IMPORTED=$(awk '/import /,/ from/' $IMPORT_FILE | grep -ow "$CLASS")
            SELF_IMPORT=$(grep -oP "^export default class $CLASS\W" "$IMPORT_FILE")
            if [[ -z "$ALREADY_IMPORTED" && -z "$SELF_IMPORT" ]]; then 
                [ "$ADD_IMPORT" = "true" ] && sed -i "1s@^@$replacement@" "$IMPORT_FILE" 
                printf "%-45s | %-45s | \e[32m%-45s\e[0m\n" "${IMPORT_FILE##*/}" "$CLASS" "Imported Added."
            # elif [ ! -z "$ALREADY_IMPORTED" ]; then
                # printf "%-45s | %-45s | \e[35m%-45s\e[0m\n" "${IMPORT_FILE##*/}" "$CLASS" "Already imported."
            # elif [ ! -z "$SELF_IMPORT" ]; then
                # printf "%-45s | %-45s | \e[33m%-45s\e[0m\n" "${IMPORT_FILE##*/}" "$CLASS" "Self Import."
            fi
        done
    fi 
done
