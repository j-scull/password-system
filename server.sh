#/bin/bash

if [ ! -e "server.pipe" ]; then
	mkfifo "server.pipe"
else
	rm server.pipe
	mkfifo "server.pipe"
fi
while true; do

	read -r -a arr < server.pipe
	case "${arr[1]}" in
		init)
			./init.sh "${arr[@]:2}" >& ${arr[0]}.pipe
			;;
		insert)
			./insert.sh "${arr[@]:2}" >& ${arr[0]}.pipe
			;;
		show)
			./show.sh "${arr[@]:2}" >& ${arr[0]}.pipe
			;;
		update)
			./insert.sh ${arr[@]:2:2} "f" ${arr[4]} >& ${arr[0]}.pipe
			;;
		rm)
			./rm.sh "${arr[@]:2}" >& ${arr[0]}.pipe
			;;
		ls)
			./ls.sh "${arr[@]:2}" >& ${arr[0]}.pipe 
			;;
		shutdown)
			echo "OK: shuting down" > ${arr[0]}.pipe
			rm server.pipe
			break
			;;
		*)
			echo "Error: bad request" > ${arr[0]}.pipe
			rm server.pipe
			exit 1
		esac
done


