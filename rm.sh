#!/bin/bash

if [ $# -ne 2 ]; then
	echo "Error: parameters problem" >&2
	exit 1
fi
if [ ! -e "$1" ]; then
	echo "Error: user does not exist" >&2
	exit 1
fi
./P.sh "$1"
if [ ! -e "$1"/"$2" ]; then
	echo "Error: service does not exist" >&2
	./V.sh "$1"
	exit 1
else
	rm "$1"/"$2"
	echo "OK: service removed"
	./V.sh "$1"
fi
