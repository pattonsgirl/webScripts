#!/bin/bash

echo "RUN ALL METHODS AS SUDO AND INSTALL PWGEN"
echo "Add instructor account first"
echo "Template index.html needs to be in current dir"
echo "Usage:"
echo "CS2800Users filename.txt - IDs will be in CS2800IDS.txt"
echo "CS3800Users filename.txt - IDs will be in CS3800IDS.txt"
echo "removeList filename.txt - Users in file and their directories will be removed"

#Original script to add users to web server and restrict ssh access
newUsersBatch(){
	#reads off from user file
	USERS=$(cat "students.txt")
	for user in $USERS
	do
  		#be sure to reconfigures separator characters if necessary
  		password=$(python ./passwdgen.py)
  
  		#may need to edit this...  username:password:uid:gid:fullname:/home/dir:/bin/shell
  		echo "$user:$password::33::/home/$user:/bin/false" > userfile
		#newusers broke on batches, split into one at a time
		$(newusers userfile)
	done
}

CS2800Users(){
	#if there is an old copy of user IDs, delete it
	rm CS2800IDS.txt
	#reads off from user file
	USERS=$(cat $1)
	instruct=starkey
	ipasswd=clarks9gables
	#ta=name
	#tapasswd=pwgen 5 1
	for user in $USERS
	do
  		#be sure to reconfigures separator characters if necessary
		echo "Giving $user a random password"
		#relies on pwgen
		password=$(pwgen 5 1)
  		echo "Outputting to master list CS2800IDS.txt"
		echo "$user - $password" >> CS2800IDS.txt
  		#username:password:uid:gid:fullname:/home/dir:/bin/shell
  		echo "$user:$password::::/home/$user:/bin/bash" > userfile
		#newusers broke on batches, split into one at a time
		$(newusers userfile)
		echo "$user has been created.  Adding those with permissions to see student files"
		usermod -a -G $user $instruct
		#usermod -a -G $user $ta
		#htpasswd -b get passwd from cmd, -c to create first time in directory
		echo "Creating .htpasswd"
		mkdir -v /home/$user/html/
		htpasswd -cb /home/$user/html/.htpasswd $user $password
		htpasswd -b /home/$user/html/.htpasswd $instruct $ipasswd
		#htpasswd -b /home/$user/html/.htpasswd $ta $tapasswd
		echo "Creating .htaccess"
		#password protection to restrict to just that user and instructor
		#Changed from Require valid-user
		printf "AuthType Basic\nAuthName \"Enter Twilight Zone\"\nAuthUserFile /home/$user/html/.htpasswd\nRequire user $user $instruct" > /home/$user/html/.htaccess
		echo "Creating index.html in dir html for $user"
		cp index.html /home/$user/html/index.html
		#need good way to retrict to sftp only.  Students can ssh and sftp as of 2/3/2016
		#echo "Add $user to sftponly group"
		#usermod -a -G sftponly $user
		#/etc/ssh/sshd_config may have useful things
		echo "Locking down sftp and ssh access for $user"
		chown -R www-data /home/$user
		chgrp -R $user /home/$user
		chmod -R ug+rw /home/$user 
		chmod -R o-rwx /home/$user
		echo "Making it so permissions persist"
		chmod -R ug+s /home/$user
	done
}

CS3800Users(){
	rm CS3800IDS.txt
	#reads off from user file
	USERS=$(cat $1)
	instruct=starkey
	ipasswd=clarks9gables
	for user in $USERS
	do
  		#be sure to reconfigures separator characters if necessary
		echo "Giving $user a random password"  		
		password=$(python ./passwdgen.py)
  		echo "Outputting to master list CS2800IDS.txt"
		echo "$user - $password" >> CS3800IDS.txt
  		#username:password:uid:gid:fullname:/home/dir:/bin/shell
  		echo "$user:$password::::/home/$user:/bin/bash" > userfile
		#newusers broke on batches, split into one at a time
		$(newusers userfile)
		echo "$user has been created.  Adding those with permissions to see all"
		usermod -a -G $user $instruct
		#htpasswd -b get passwd from cmd, -c to create first time in directory
		echo "Creating .htpasswd"
		mkdir /home/$user/html/
		htpasswd -cb /home/$user/html/.htpasswd $user $password
		htpasswd -b /home/$user/html/.htpasswd $instruct $ipasswd
		echo "Creating .htaccess"
		printf "AuthType Basic\nAuthName \"Restricted Content\"\nAuthUserFile /home/$user/html/.htpasswd\nRequire valid-user" > /home/$user/html/.htaccess
		echo "Creating index.html in dir html for $user"
		cp index.html /home/$user/html/index.html
		#need good way to retrict to sftp only.  Students can ssh and sftp as of 2/3/2016		
		#echo "Add $user to sftponly group"
		#usermod -a -G sftponly $user
		#/etc/ssh/sshd_config may have useful things
		echo "Locking down sftp and ssh access for $user"		
		chown -R www-data /home/$user
		chgrp -R $user /home/$user
		chmod -R ug+rw /home/$user 
		chmod -R o-rwx /home/$user
		echo "Making it so permissions persist"
		chmod -R ug+s /home/$user
	done
}


removeList(){
	USERS=$(cat $1)
	for user in $USERS
	do
		deluser --quiet $user
		delgroup $user
		rm -R /home/$user
	done
	echo "Remove User ID list separately - is autoremoved if creating new accounts"
}
