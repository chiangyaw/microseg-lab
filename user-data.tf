locals {
    user_data_wordpress = <<EOF
#!/usr/bin/bash
sudo apt-get update && \
sudo apt-get -y upgrade && \
sudo apt-get install -y apache2 php libapache2-mod-php php-mysql && \
sudo systemctl stop ufw && sudo systemctl disable ufw && \
sudo systemctl enable apache2 && \
sudo systemctl restart apache2 && \
cd /var/www/html && \
sudo wget https://wordpress.org/latest.tar.gz && \
sudo tar -zxvf latest.tar.gz && \
sudo cp -r wordpress/* /var/www/html/ && \
sudo rm -rf wordpress && \
sudo rm -rf latest.tar.gz && \
sudo chmod -R 755 wp-content && \
sudo chown -R www-data:www-data wp-content && \
sudo chown -R www-data:www-data /var/www/html/ && \
sudo rm -rf index.html && \
sudo systemctl restart apache2 && \
sudo echo "done"
EOF


    user_data_mariadb = <<EOF
#!/usr/bin/bash
sudo apt-get update && \
sudo apt-get -y upgrade && \
sudo apt-get install -y mariadb-server && \
sudo sed -i -e"s/^bind-address\s*=\s*127.0.0.1/bind-address = 0.0.0.0/" /etc/mysql/mariadb.conf.d/50-server.cnf && \
sudo systemctl stop ufw && sudo systemctl disable ufw && \
sudo systemctl enable mariadb.service && \
sudo systemctl restart mariadb && \
echo "CREATE DATABASE wordpress;" > create_db.sql && \
echo "CREATE USER 'wp_user'@'%' IDENTIFIED BY 'my_password1';" >> create_db.sql && \
echo "GRANT ALL PRIVILEGES ON wordpress.* TO 'wp_user'@'%';" >> create_db.sql && \
echo "FLUSH PRIVILEGES;" >> create_db.sql && \
echo "exit" >> create_db.sql && \
sudo mysql -h localhost -u root < create_db.sql && \
rm create_db.sql && \
sudo echo "done"
EOF


    user_data_bastian = <<EOF
#!/usr/bin/bash
sudo apt-get update && \
sudo apt-get -y upgrade && \
sudo apt-get -y install nmap net-tools mariadb-client && \
curl -LO "https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl" && \
chmod +x kubectl && \
sudo mv kubectl /usr/local/bin/ && \
sudo curl -o /usr/local/bin/apoctl https://download.aporeto.com/prismacloud/app/apoctl/linux/apoctl && \
sudo chmod +x /usr/local/bin/apoctl && \
sudo echo "done"
EOF

}
