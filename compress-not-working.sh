#!/bin/bash

# Define the directory to search for files in
rootDir=$1

# Define the output file path
outputFilePath=$2

# Define a function to compress the code
function compress_code {
    # Read the code from standard input
    read code

    # Replace string literals with placeholders
    placeholders=()
    i=0
    while read -r line; do
        placeholder="p$i"
        placeholders+=("$placeholder:$line")
        i=$((i+1))
    done <<< "$(sed -E 's/(\"|\x27).+?\1/{\0}/g' <<< "$code")"

    # Replace repeated words/phrases with placeholders
    while read -r line; do
        words=()
        while read -r word; do
            if [[ "${placeholders[@]}" =~ "${word}:" ]]; then
                words+=("${BASH_REMATCH[0]}")
            else
                words+=("$word")
            fi
        done <<< "$(sed -E 's/[[:punct:]]//g' <<< "$line")"
        echo "${words[@]}"
    done <<< "$code" | awk -v placeholders="$placeholders" '
        BEGIN {
            split(placeholders, p, " ")
            for (i in p) {
                split(p[i], parts, ":")
                placeholders[parts[1]] = parts[2]
            }
        }
        {
            for (i=1; i<=NF; i++) {
                if ($i in placeholders) {
                    printf "d{%s:%s} ", $i, placeholders[$i]
                } else {
                    printf "%s ", $i
                }
            }
            printf "\n"
        }
    '

}

# Find all files in the root directory and its subdirectories and compress their code
find "$rootDir" -type f -print0 | while read -d $'\0' file; do
    echo "//file:$file" >> "$outputFilePath"
    compress_code < "$file" >> "$outputFilePath"
    echo "" >> "$outputFilePath"
done
