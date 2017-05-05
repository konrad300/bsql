#!/usr/bin/env bash

set -euo pipefail # defensive programming
set -f # no expansion

source "${BSQL_DIR}/output_formatters.sh"

select_command() {
    local columns="$1"
    local filename="$2"
    local output_type="$3"

    # check for file existance
    if [ ! -f "$filename" ]; then
        echo "File *$filename* does not exist"
        exit 1
    fi

    # get command columns
    declare -a commandCols=()
    while IFS=, read -ra line; do
        commandCols=( "${line[@]}" )
    done <<< $columns

    # get file columns
    declare -a fileCols=()
    while IFS=, read -ra line; do
        fileCols=( "${line[@]}" )
    done < <(head -n 1 $filename)

    # verify existance of columns
    # get indexes of columns to display
    declare -a indexesToDisplay=()
    if [ "$columns" = "*" ]; then
        let maxIndex=${#fileCols[@]}-1
        indexesToDisplay=($(seq 0 ${maxIndex}))
    else
    for i in ${!commandCols[@]}; do
        local exists=0
        for j in ${!fileCols[@]}; do
            if [ "${commandCols[$i],,}" = "${fileCols[$j],,}" ]; then
                indexesToDisplay+=("$j")
                exists=1
            fi
        done
        if [ "$exists" -ne 1 ]; then
            echo "Column *${commandCols[$i]}* does not exist"
            exit 1
        fi
    done
    fi

    # display results
    case "$output_type" in
    csv) display_as_csv "$filename" "${indexesToDisplay[@]}" ;;
    tsv) display_as_tsv "$filename" "${indexesToDisplay[@]}" ;;
    html) display_as_html_table "$filename" "${indexesToDisplay[@]}" ;;
    esac
}
