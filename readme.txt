Password Management System


Short Description:

Allows clients to store, retrieve and edit their passwords for various applications.
Implements a client interface and a server functionality.


Scripts:


server.sh

	- implements the server functionality
	- recieves commands from the client, calls basic scripts


client.sh 

	-implements the client functionality.
	-takes input commands from user requests server to perform task
	-the commands are:
		
		- init: create a service,  i.e. an application that requires a password  

		- insert: save a password for a service

		- show: show the password for a servce

		- edit: retrieve the password and open in editor

		- generate: generates a random password for a service using openssl

		- ls: show all the clients services

		- rm: removes a service

		- shutdown: shutsdown the system


init.sh

	- initialises a service

insert.sh

	- inserts a password for a service

rm.sh

	- removes a service

ls.sh

	- lists a clients services

show.sh

	- retrieves the password for a service

encrypt.sh

	- encrypts a payload using openssl

decrypt.sh

	- decrypts a payload using openssl

P.sh

	- applies a semaphore to a file when writing

V.sh

	- removes a semaphore applied to a file 