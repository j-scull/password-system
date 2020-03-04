#!/bin/bash

if [ $# -lt 2 ]; then
	echo "Error: parameters problem" >&2
	exit 1
fi
if [ ! -e "$1.pipe" ]; then
	mkfifo "$1.pipe"
else
	rm "$1.pipe"
	mkfifo "$1.pipe"
fi
case "$2" in 
	init)
		echo "$@" > server.pipe
		cat $1.pipe
		;;
	insert)
		if [ $# -ne 4 ]; then
			echo "Error: parameters problem"
		else
			#check if user exists
			echo "$1 ls $3" > server.pipe
			U=$(grep . $1.pipe)
			checkU=$(echo $U | grep -c '^Error:')
			if [ $checkU -eq 1 ]; then
				echo "Error: User doesn't exist"
				exit 1
			fi

			#check service that service doesn't already exist 
			echo "$1 show $3 $4" >server.pipe
			S=$(grep . $1.pipe)
			checkS=$(echo $S | grep -c '^Error:')
			if [ $checkS -eq 0 ]; then
				echo "Error: service already exists"
				exit 1
			fi
			
			#promt user for login and password
			echo "Please write login: "
			read -r log
			echo "Please write password: "
			read  -r pswd
			enclog=$(echo $(./encrypt.sh hippopotamus "$log") | sed 's/ //g')		
			encpass=$(echo $(./encrypt.sh hippopotamus "$pswd") | sed 's/ //g')
			echo "$@ login:"$enclog"\npassword:"$encpass"" > server.pipe
			cat $1.pipe
		
		fi		

		;;
	show)
		if [ $# -ne 4 ]; then
			echo "Show requires 4 parameters"
		else
			echo "$@" > server.pipe
			while read line; do
				echo $line >> msg
			done < $1.pipe
			
			#check that user/service exists before attempting to decrypt
			check2=$(grep -c '^Error:' msg)
			if [ "$check2" -eq 1 ]; then
				cat msg
			else
				l=$( grep '^login' msg | cut -d":" -f2)
				dlog=$(./decrypt.sh hippopotamus $l)
				p=$(grep '^password' msg | cut -d":" -f2)
				dpass=$(./decrypt.sh hippopotamus $p)
				echo "$3's login for $4 is: $dlog"
				echo "$3's password for $4 is: $dpass"
			fi
			rm msg
		fi
		;;
        edit)
                if [ $# -ne 4 ]; then
                        echo "Edit requires 4 parameters"
                else
                        temp=mktemp
                        echo "$1 show $3 $4" > server.pipe
			
			#check that user/service exist before decrypting and opening
                        text=$(grep . $1.pipe)
			check3=$(echo $text | grep -c '^Error:')
			if [ "$check3" -eq 1 ]; then
				echo $text
			else
			
                        	elog=$(echo "$text" | grep '^login' | cut -d":" -f2)
                     	        epass=$(echo "$text" | grep '^password' | cut -d":" -f2)
                     	        echo "login:$(./decrypt.sh hippopotamus $elog)" > temp
                     	        echo "password:$(./decrypt.sh hippopotamus $epass)" >> temp
                     	        vi temp

				#catch invalid login and password
                                count=$(grep -c . temp)
                                if [ "$count" -ne 2 ]; then
                     	               echo "Error: Invalid login/password" >&2
                     	               exit 1
                     	        fi
                         	 count=$(head -n1 temp | grep -c '^login:')
                                if [ "$count" -ne 1 ]; then
                     	               echo "Error: Must be format:" >&2
                       	               echo "login:\"mylogin\""
                          	       echo "password:\"mypassword\""
               	                       exit 1
                      	        fi
                                count=$(tail -n1 temp | grep -c '^password:')
				if [ "$count" -ne 1 ]; then
					echo "Error: Must be format:" >&2	
					echo "login:\"mylogin\""
					echo "password:\"mypassowrd\""
					exit 1
				fi

				newlog=$(grep '^login:'  temp | cut -d":" -f2-)
				newpass=$(grep '^password:' temp | cut -d":" -f2-)

			
				enewlog=$(echo $(./encrypt.sh hippopotamus "$newlog") | sed 's/ //g')
				enewpass=$(echo $(./encrypt.sh hippopotamus "$newpass") | sed 's/ //g')
				echo "$@ login:$enewlog\npassword:$enewpass" | sed s/edit/update/ > server.pipe
				rm temp	
				cat $1.pipe
			fi
		fi		
		;;
	generate)
		echo "Please write login: "
		read log
		pswd=$(openssl rand -base64 8)	
		echo "Password is: $pswd"
		enlog=$(echo $(./encrypt.sh hippopotamus "$log") | sed 's/ //g')
		enpass=$(echo $(./encrypt.sh hippopotamus "$pswd") | sed 's/ //g')
		echo  "$@ login:$enlog\npassword:$enpass" | sed s/generate/insert/ > server.pipe
		cat $1.pipe	
		;;

	ls)
		echo "$@" > server.pipe
		cat $1.pipe			
		;;
	rm)
		if [ $# -ne 4 ]; then
			echo "rm requires 4 parameters"
		else
			echo "$@" > server.pipe
			cat $1.pipe
		fi
		;;
	shutdown)
		echo "$@" > server.pipe
		cat $1.pipe
		;;
	*)
		echo "Error: not a valid request" 
		rm $1.pipe
		exit 1
esac
rm $1.pipe





