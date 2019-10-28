# new mysql version do not allow root login without sudo therefore phpmyadmin cant use that account
CREATE USER devuser@localhost IDENTIFIED BY '1';
GRANT ALL PRIVILEGES ON *.* TO 'devuser'@'localhost' WITH GRANT OPTION;
