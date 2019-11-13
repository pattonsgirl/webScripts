#!/bin/bash

echo -e "\n\n"
echo "1. INSTALL PWGEN"
echo "2. Add instructor account(s) first"
echo "3. Template index.html needs to be in current dir"
echo "4. To use commands in script, run . master-usergen.sh"
echo -e "\n\n"
echo "Function Calls:"
echo "studentAccounts file_name.txt 	- Creates account based on list.  Add instructors with addInstruct"
echo "singleUser 			- Creates a single user.  Provide username after command"
echo "INSTRUCT_ACCT 			- Create files for instructor account.  Provide username and password after command"
echo "addInstruct file_name.txt 	- Add an instructor account.  Provide instructor username after command"
echo "removeList file_name.txt 		- Users in file and their directories will be removed"
echo "removeUSER 			- Removes a single user.  Provide username after command"
echo -e "\n\n"


studentAccounts(){
	#if there is an old copy of user IDs, delete it
	#TODO: make file based on date
	#reads off from user file
	USERS=$(cat $1)
	echo "Enter file name to save IDs and press [ENTER]:"
        read filename
	for user in $USERS
	do
  		#be sure to reconfigures separator characters if necessary
		echo "Giving $user a random password"
		#relies on pwgen
		password=$(pwgen -v 5 1)
		echo "$user - $password" >> $filename
  		echo "$user:$password::::/home/$user:/bin/bash" > userfile
		#newusers broke on batches, split into one at a time
		$(newusers userfile)
		#echo "$user has been created.  Adding those with permissions to see student files"
		#usermod -a -G $user $instruct
		#htpasswd -b get passwd from cmd, -c to create first time in directory
		echo "Creating .htpasswd"
		mkdir -v /home/$user/html/
		htpasswd -cb /home/$user/html/.htpasswd $user $password
		#htpasswd -b /home/$user/html/.htpasswd $instruct $ipasswd
		echo "Creating .htaccess"
		#password protection to restrict to just that user and instructor
		printf "AuthType Basic\nAuthName \"Enter Twilight Zone\"\nAuthUserFile /home/$user/html/.htpasswd\nRequire user $user" > /home/$user/html/.htaccess
		echo "Creating index.html in dir html for $user"
		cp index.html /home/$user/html/index.html
		#need good way to retrict to sftp only.  Students can ssh and sftp as of 2/3/2016
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

singleUser(){
        echo -n "Enter student name and press [ENTER]: "
	read user
        #be sure to reconfigures separator characters if necessary
        echo "Giving $user a random password"
        #relies on pwgen
        password=$(pwgen -v 5 1)
        echo "Enter filename to save single user and press [ENTER]"
	read filename
        echo "$user - $password" && >> filename
        #username:password:uid:gid:fullname:/home/dir:/bin/shell
        echo "$user:$password::::/home/$user:/bin/bash" > userfile
        #newusers broke on batches, split into one at a time
        $(newusers userfile)
        echo "$user has been created."
	echo "Adding those with permissions to see student files"
        usermod -a -G $user $instruct
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
}



INSTRUCT_ACCT(){
        echo "Enter instructor name and press [ENTER]"
        read instruct
        echo "Enter instructor password and press [ENTER]"
        read instruct_pass
        #echo "$instruct:$instruct_pass::::/home/$instruct:/bin/bash" > userfile
        #newusers broke on batches, split into one at a time
        #usermod -a -G $instruct
        #htpasswd -b get passwd from cmd, -c to create first time in directory
        echo "Creating .htpasswd"
        mkdir -v /home/$instruct/html/
        htpasswd -cb /home/$instruct/html/.htpasswd $instruct $instruct_pass
        echo "Creating .htaccess"
        #password protection to restrict to just that user and instructor
        #Changed from Require valid-user
        printf "AuthType Basic\nAuthName \"Enter Twilight Zone\"\nAuthUserFile /home/$instruct/html/.htpasswd\nRequire user $instruct" > /home/$instruct/html/.htaccess
        echo "Creating index.html in dir html for $instruct"
        cp index.html /home/$instruct/html/index.html
        echo "Locking down sftp and ssh access for $instruct"
        chown -R www-data /home/$instruct
        chgrp -R $instruct /home/$instruct
        chmod -R ug+rw /home/$instruct
        chmod -R o-rwx /home/$instruct
        echo "Making it so permissions persist"
        chmod -R ug+s /home/$instruct
}


addInstruct(){
        #reads off from user file
        USERS=$(cat $1)
        echo "Enter instructor name and press [ENTER]"
	read instruct
	echo "Enter instructor password and press [ENTER]"
        read instruct_pass
        echo "$instruct - $instruct_pass"
        for user in $USERS
        do
                echo "$user exists - adding TA"
                usermod -a -G $user $instruct
                htpasswd -b /home/$user/html/.htpasswd $instruct $instruct_pass
                echo "Fixing .htaccess"
                #password protection to restrict to just that user and instructor
		echo -n " $instruct" >> /home/$user/html/.htaccess
		#sed -i '$ s/$instruct' /home/$user/html/.htaccess
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
 	echo "REMINDER: Remove User ID list"
}

removeUSER(){
 	echo -n "Enter name of user to REMOVE and press [ENTER]: "
	read user
 	deluser --quiet $user
 	delgroup $user
 	rm -R /home/$user
}
