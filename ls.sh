#!/bin/bash

if [ $# -eq 0 ]; then
	echo "Error: parameters problem" >&2
	exit 1
fi	
if [ $# -gt 2 ]; then
	echo "Error: parameters problem" >&2
	exit 1
fi
if [ $# -eq 0 ]; then
	echo "Error: parameters problem" >&2
	exit 1
fi
if [ $# -eq 2 ]; then
	if [ ! -e "$1"/"$2" ]; then
		echo "Error: folder does not exist" >&2
		exit 1
	else
		if [ -d "$2" ]; then
			cd "$1"
			tree "$2"
			cd ../
		else
			echo "Error: $2 is not a folder" >&2
			exit 1
		fi
	fi	
else
	if [ -e "$1" ]; then
		if [ -d "$1" ]; then
			tree "$1"
		else
			echo "Error: $1 is not a folder" >&2
			exit 1
		fi
	else
		echo "Error: folder does not exist" >&2
		exit 1
	fi
fi
