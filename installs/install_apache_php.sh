#!/bin/bash

if [ ! -f ../env ]; then
    cp ../env.sample ../env
fi

chown $SUDO_USER:$SUDO_USER env

source ../env

apt-get update -y
apt upgrade -y

install_software(){

	echo "------------------------------------------------------------------"
	echo "     Certbot, Apache2, Php7.2 Composer installation        "
	echo "------------------------------------------------------------------"

	apt install -y apache2

	apt install -y php7.2 php7.2-common php7.2-curl php7.2-pdo php7.2-mysql php7.2-opcache php7.2-xml php7.2-gd php7.2-mysql php7.2-intl php7.2-mbstring php7.2-bcmath php7.2-json php7.2-iconv php7.2-soap php7.2-zip php7.2-xsl -y

	apt install -y composer

	apt install -y mysql-server mysql-common mysql-client

	rm /etc/php/7.2/cli/php.ini
	cp /etc/php/7.2/apache2/php.ini /etc/php/7.2/cli/

	systemctl enable apache2
	systemctl enable mysql
}

install_software