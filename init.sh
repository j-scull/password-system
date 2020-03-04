#!/bin/bash

if [ $# -ne 1 ];then
	echo "Error: parameter problem" >&2
	exit 1
fi
./P.sh "$1" 
if [ !  -e "$1" ]; then
	mkdir "$1"
	echo "OK: user created" 
	./V.sh "$1"
else
	./V.sh "$1"
	echo "Error: user already exists!" >&2
	exit 1
fi
