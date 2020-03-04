#!/bin/bash
if [ $# -lt 3 ]; then
	echo "Error: parameters problem" >&2
	exit 1
fi
if [ $# -gt 4 ]; then
	echo "Error: parameters problem" >&2
	exit 1
fi
if [ ! -e "$1" ]; then
	echo "Error: user does not exist" >&2
	exit 1
fi
./P.sh "$1"
if [ $# -eq 3 ]; then
	if [ -e "$1"/"$2" ]; then
		echo "Error: service already exists" >&2
		./V.sh "$1"
		exit 1	
	else
		echo -e "$3" >> "$1"/"$2"
		echo "OK: service created"
		./V.sh "$1"
	fi
else
	if [ ! -e "$1"/"$2" ]; then
		echo "Error: can't update - service doesn't exist" >&2
		./V.sh "$1"
		exit 1	
	fi
	if [ "$3" = 'f' ]; then
		echo -e "$4" > "$1"/"$2"
		echo "OK: service updated"
		./V.sh "$1"
	else
		echo "Error: "$3" is not an option" >&2
		./V.sh "$1"
		exit 1
	fi
fi
