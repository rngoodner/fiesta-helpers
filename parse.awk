#!/bin/awk -f

BEGIN {
	line=1
}

/.*Total Time.*/ {
	print "Found [" line "]: " $0
	vals[line++]=$3
}

END {
	printf "["
	printf "%s", vals[1]
	for (i=2; i<=length(vals); i++) {
		printf ", %s", vals[i]
	}
	print "]"
}
