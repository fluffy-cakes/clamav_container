/^ID/,/^Sum/ {
    if ($1 ~ /[0-9]/) {
        id = $1
    }
    if ($2 ~ /100/) {
        printme = 1
    }
}
printme {
    print id
    printme = 0
}