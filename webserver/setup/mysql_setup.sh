# mysql setup
# pseudo-script

# # install and configure mysql--------------------------------------------------------------
$ sudo apt install mysql-server
# ## enter mysql prompt:
$ sudo mysql
# # mysql> ALTER USER 'root'@'localhost' IDENTIFIED WITH mysql_native_password BY 'password';
$ mysql_secure_installation
$ mysql -u root -p
# # mysql> ALTER USER 'root'@'localhost' IDENTIFIED WITH auth_socket;
# # mysql> FLUSH PRIVILEGES;
# 
# # create mysql db and user----------------------------------------------------------------
$ sudo mysql -u root -p
# # mysql> CREATE DATABASE mysite;
# # mysql> CREATE USER 'username'@'localhost' IDENTIFIED BY 'yourPassword';
# # mysql> GRANT PRIVILEGE ON database.table TO 'username'@'localhost';
# # mysql> FLUSH PRIVILEGES;
