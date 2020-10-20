#!/bin/bash
MODULE=$1
MODULE_PATH=$2
ADD_IMPORT=$3

printf "%-45s | %-45s | %-45s\n" "File" "Import" "Status"
printf "%-45s | %-45s | %-45s\n" "" "" ""
grep -oP "(?<=^export { default as )(\w*)\b" "$MODULE_PATH" |  while read -r line;
do
    CLASS="$line"
    replacement="import { ${CLASS} } from '/modules/${MODULE}.js';\n"

    grep -rlP "new $CLASS\W|\b$CLASS\.|\bextends $CLASS\b" "$HOME/development/trim5/public/" --exclude-dir "$HOME/development/trim5/public/modules" | sort | while read filename;   
    do 
        ALREADY_IMPORTED=$(awk '/import /,/ from/' $filename | grep -ow "$CLASS")
        SELF_IMPORT=$(grep -oP "^export default class $CLASS\W" "$filename")
        if [[ -z "$ALREADY_IMPORTED" && -z "$SELF_IMPORT" ]]; then 
            [ "$ADD_IMPORT" = "true" ] && sed -i "1s@^@$replacement@" "$filename" 
            printf "%-45s | %-45s | \e[32m%-45s\e[0m\n" "${filename##*/}" "$CLASS" "Imported Added."
        elif [ ! -z "$ALREADY_IMPORTED" ]; then
            printf "%-45s | %-45s | \e[35m%-45s\e[0m\n" "${filename##*/}" "$CLASS" "Already imported."
        elif [ ! -z "$SELF_IMPORT" ]; then
            printf "%-45s | %-45s | \e[33m%-45s\e[0m\n" "${filename##*/}" "$CLASS" "Self Import."
        fi
    done 
done 
