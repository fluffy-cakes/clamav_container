#!/bin/bash

SCANDIRECTORY="/data/scan"
files=$(shopt -s nullglob dotglob; echo "${SCANDIRECTORY}/*")

if (( ${#files} )); then
    printf "Found files to process\n"

    for file in "/data/scan"/* ; do
        filename=$(basename "$file")
        printf "Processing %s/%s\n" "${SCANDIRECTORY}" "${filename}"
        printf "[%s]\n" "$(date +'%Y-%m-%d %T')"

        printf "Checking and removing completed torrents\n"
        transmission-remote "${ENVIP}:9091" --list
        torrentList=$(transmission-remote "${ENVIP}:9091" --list | awk -f /usr/local/bin/awk.awk)
        for i in $torrentList; do
            printf "Removing torrent ID %s\n" "$i"
            transmission-remote "${ENVIP}:9091" --torrent "$i" --remove
        done

        printf "Running scan on completed torrents"
        clamscan -rio --remove=yes ${SCANDIRECTORY} > ${SCANDIRECTORY}/info 2>&1

        if [ -e "${SCANDIRECTORY}/${filename}" ]; then
            printf "  --> File ok, moving\n"
            mv -f "${SCANDIRECTORY}/${filename}" "/data/done/${filename}"
            rm ${SCANDIRECTORY}/info
        fi
    done
    printf "Done with processing\n"
fi
