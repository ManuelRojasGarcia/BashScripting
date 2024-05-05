
function convertiramillones(cantidad) {
    if (cantidad ~ /M/) {
        return int(substr(cantidad, 2) * 1000000)
    } else if (cantidad ~ /K/) {
        return int(substr(cantidad, 2) * 1000)
    } else {
        return int(cantidad)
    }
}

BEGIN {
    FS = ","
    FPAT = "([^,]+)|(\"[^\"]+\")"
    if (subject == "") {
        print "Parameter not found"
	exit
    }
    if (missingParam == "Other") {
        print "Parameter not found"
    }
    if (subject == "MissingValue") {
        print "No films found"
    }
}

($9 == subject || $9 ~ "^" subject "/") && ($5 ~ /^\$/) {
    count++
   
    box_office = convertiramillones($5)

    if (box_office > maxRecaudacion || maxRecaudacion == "") {
        maxRecaudacion = box_office
        maxRecaudacionok = box_office ", " $1 ", " $4
    }

    if (minRecaudacion == "" || box_office < minRecaudacion) {
        minRecaudacion = box_office
        minRecaudacionok = box_office ", " $1 ", " $4
    }
}

END {
    if (count > 0) {
        print "Total films: " count
        print maxRecaudacionok
        print minRecaudacionok
    }
}
