#!/bin/bash

files=$(shopt -s nullglob dotglob; echo /data/scan/*)

if (( ${#files} )); then
    printf "Found files to process\n"

    for file in "/data/scan"/* ; do
        filename=$(basename "$file")
        printf "Processing /data/scan/%s\n" "${filename}"
        printf "[%s]\n" "$(date +'%Y-%m-%d %T')"

        printf "Checking and removing completed torrents\n"
        transmission-remote "${ENVIP}:9091" --list
        torrentList=$(transmission-remote "${ENVIP}:9091" --list | awk -f /usr/local/bin/awk.awk)
        for i in $torrentList; do
            printf "Removing torrent ID %s\n" "$i"
            transmission-remote "${ENVIP}:9091" --torrent "$i" --remove
        done

        printf "Running scan on completed torrents"
        clamscan -rio --remove=yes > /data/scan/info 2>&1

        if [ -e "/data/scan/${filename}" ]; then
            printf "  --> File ok, moving\n"
            mv -f "/data/scan/${filename}" "/data/done/${filename}"
            rm /data/scan/info
        fi
    done
    printf "Done with processing\n"
fi
