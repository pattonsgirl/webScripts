Sites and notes from pre-script account creation:

install apache2
a2enmod userdir - requires service restart
nano /etc/apache2/mods-enabled/userdir.conf - check where users need to put files for apache to read
    UserDir and Directory need to reference html
install apache2-utils - can now use htpasswd to lock web dirs
add ta as user and instructor




Enable all the directories:
http://www.techytalk.info/enable-userdir-apache-module-ubuntu-debian-based-linux-distributions/

Password Authentication to website

https://www.digitalocean.com/community/tutorials/how-to-set-up-password-authentication-with-apache-on-ubuntu-14-04 

  22  apt-get install apache2-utils
   23  htpasswd -c .htpasswd kduncan
   24  service apache2 restart
   25  nano .htaccess

AuthType Basic
AuthName "Restricted Content"
AuthUserFile /home/*/public_html/.htpasswd
Require valid-user

   26  service apache2 restart

Lockdown FTP:

http://serverfault.com/questions/357108/what-permissions-should-my-website-files-folders-have-on-a-linux-webserver

make apache the user / owner (www-data), give rwx
create group with student and instructor, give rwx
all give ---
