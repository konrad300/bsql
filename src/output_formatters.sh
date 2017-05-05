#!/usr/bin/env bash

set -euo pipefail # defensive programming
set -f # no expansion

display_as_csv() {
    local filename="${1}"
    shift
    local indexesToDisplay=("$@")

    while IFS=, read -ra line; do
        for i in "${!indexesToDisplay[@]}"; do
            local index="${indexesToDisplay[$i]}"
            printf "${line[$index]}"
            if [[ $i+1 -ne "${#indexesToDisplay[@]}" ]]; then
                printf ","
            fi
        done
        printf "\n"
    done < $filename
}

display_as_tsv() {
    local filename="${1}"
    shift
    local indexesToDisplay=("$@")

    while IFS=, read -ra line; do
        for i in "${!indexesToDisplay[@]}"; do
            local index="${indexesToDisplay[$i]}"
            printf "${line[$index]}"
            if [[ $i+1 -ne "${#indexesToDisplay[@]}" ]]; then
                printf "	"
            fi
        done
        printf "\n"
    done < $filename
}

display_as_html_table() {
    local filename="${1}"
    shift
    local indexesToDisplay=("$@")

    printf "<table>\n"
    while IFS=, read -ra line; do
        printf "<tr>\n"
        for i in "${!indexesToDisplay[@]}"; do
            local index="${indexesToDisplay[$i]}"
            printf "    <th>${line[$index]}"
            if [[ $i+1 -ne "${#indexesToDisplay[@]}" ]]; then
                printf "</th>\n"
            fi
        done
        printf "</th>\n"
        printf "</tr>\n"
    done < <(head -n 1 $filename)

    while IFS=, read -ra line; do
        printf "<tr>\n"
        for i in "${!indexesToDisplay[@]}"; do
            local index="${indexesToDisplay[$i]}"
            printf "    <td>${line[$index]}"
            if [[ $i+1 -ne "${#indexesToDisplay[@]}" ]]; then
                printf "</td>\n"
            fi
        done
        printf "</td>\n"
        printf "</tr>\n"
    done < <(tail -n +2 $filename)
    printf "</table>\n"
}
