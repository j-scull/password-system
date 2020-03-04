#!/bin/bash

if [ $# -lt 2 ]; then
	echo "Error: parameters problem" >&2
	exit 1
fi
if [ ! -e "$1" ]; then
	echo "Error: user does not exist" >&2
	exit 1
fi
if [ ! -e "$1"/"$2" ]; then
	echo "Error: service does not exist" >&2
	exit 1
else
	cat "$1"/"$2"
fi



