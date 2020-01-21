This repo creates webAccounts on a standard Apache server.  
Accounts created with this script lock access between the students, but allow for instructors / tas to gain access to the student directories for grading purposes.  To protect student integrity, the browser rendered webpages are account locked by using `.htaccess` and `.htpasswd`

* `build-notes.md` contains references for server configuration that the account creation scripts are based on.
* `pwgen` is a package used by this script for password generation.
* `test.txt` contains three names to provide a sample of what the user input file should look like.
* `index.html` is a Hello World web page that is put in each user folder during account creation.

Please only reference `master-usergen-v2`.  `master-usergen` is now archived.

Type `. master-usergen-v2.sh` to load the functions into bash.

To create new accounts based on a list:  
`studentAccounts namefile.txt`  
You will be prompted to enter an ouput filename.
This creates the user accounts only.  

To create a new account for a single user:
`singleUser`  
You will be prompted for a user name.  The password will be randomly generated.  You will be prompted for an output filename.

TODO: add functionality to add instructors / TAs for a single user.

Individual instructor / TA accounts need to be made with `adduser`.  To create a web account for them similar to the student accounts:  
`INSTRUCT_ACCT`  
You will then be prompted for an instructor name and password

To give instructors / TAs access to the student accounts:  
`addInstruct namefile.txt`  
You will then be prompted for an instructor / TA username and password

To clean up users in bulk:  
`removeList namefile.txt`

To remove a single user:  
`removeUser`  
You will then be prompted for the name of the user to be deleted.