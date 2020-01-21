This repo creates webAccounts on a standard Apache server.

* `build-notes.md` contains references for server configuration that the account creation scripts are based on.
* `pwgen` is a package used by this script for password generation.
* `test.txt` contains three names to provide a sample of what the user input file should look like.
* `index.html` is a Hello World web page that is put in each user folder during account creation.

Please only reference `master-usergen-v2`.  `master-usergen` is now archived.

Type `. master-usergen-v2.sh` to load the functions into bash.

To create new accounts based on a list:  
`studentAccounts namefile.txt`  
This creates the user accounts only.  

Individual instructor / TA accounts need to be made with `adduser`.  To create a web account for them similar to the student accounts:
`INSTRUCT_ACCT`  You will then be prompted for an instructor name and password

To give instructors / TAs access to the student accounts:
`addInstruct namefile.txt`


Notes:
Instructor username and password needs to be modified in the script to let them access student files and website
Adds htaccess and htpasswd in directory html to lock down who can access a page (is set to just instructor and student)
SFTP access is resricted to student and instructor


Output:
Text file with usernames and passwords separately by " - "
