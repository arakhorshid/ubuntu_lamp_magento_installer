#!/bin/bash

if [ ! -f $PWD/env ]; then
    cp $PWD/env.sample $PWD/env
fi

chown $SUDO_USER:$SUDO_USER env

source $PWD/env

download_magento(){

    echo "------------------------------------------------------------------"
	echo "     Download Magento2 via Composer        "
	echo "------------------------------------------------------------------"

	rm -r /var/www/magento2

    mkdir /var/www/magento2/

    cp auth.json ~/.composer

    composer create-project --repository=https://repo.magento.com/ magento/project-community-edition "/var/www/magento2"

    rm ~/.composer/auth.json

	chown -R www-data:www-data /var/www/
	
}

install_magento(){
	
	su www-data

	if [ $MAGENTO_USE_SECURE -eq 1 ]; then
		/var/www/magento2/bin/magento setup:install --base-url="http://${MAGENTO_URL}" --base-url-secure="https://${MAGENTO_URL}" --backend-frontname=$MAGENTO_BACKEND_FRONTNAME --language=$MAGENTO_LANGUAGE --timezone=$MAGENTO_TIMEZONE --currency=$MAGENTO_DEFAULT_CURRENCY --db-host=$MYSQL_HOST --db-name=$MYSQL_MAGENTO_DATABASE --db-user=$MYSQL_MAGENTO_USER --db-password=$MYSQL_MAGENTO_PASSWORD --use-secure=$MAGENTO_USE_SECURE --use-secure-admin=$MAGENTO_USE_SECURE_ADMIN --admin-firstname=$MAGENTO_ADMIN_FIRSTNAME --admin-lastname=$MAGENTO_ADMIN_LASTNAME --admin-email=$MAGENTO_ADMIN_EMAIL --admin-user=$MAGENTO_ADMIN_USERNAME --admin-password=$MAGENTO_ADMIN_PASSWORD
	else
		/var/www/magento2/bin/magento setup:install --base-url=$MAGENTO_URL --backend-frontname=$MAGENTO_BACKEND_FRONTNAME --language=$MAGENTO_LANGUAGE --timezone=$MAGENTO_TIMEZONE --currency=$MAGENTO_DEFAULT_CURRENCY --db-host=$MYSQL_HOST --db-name=$MYSQL_MAGENTO_DATABASE --db-user=$MYSQL_MAGENTO_USER --db-password=$MYSQL_MAGENTO_PASSWORD --use-secure=$MAGENTO_USE_SECURE --base-url-secure=$MAGENTO_BASE_URL_SECURE --use-secure-admin=$MAGENTO_USE_SECURE_ADMIN --admin-firstname=$MAGENTO_ADMIN_FIRSTNAME --admin-lastname=$MAGENTO_ADMIN_LASTNAME --admin-email=$MAGENTO_ADMIN_EMAIL --admin-user=$MAGENTO_ADMIN_USERNAME --admin-password=$MAGENTO_ADMIN_PASSWORD
	fi
}

install_apache_virtual_host(){

    echo "------------------------------------------------------------------"
	echo "   Creating Virtualhost for magento      "
    echo "   Magentoroot /var/www/magento2"
	echo "------------------------------------------------------------------"

	a2dissite 000-default.conf

	cp magento.conf /etc/apache2/sites-available/

	if [! -z "$MAGENTO_DOMAIN" ]
	then
	    sed -i "s/example.com/$MAGENTO_DOMAIN/g"  "/etc/apache2/sites-available/magento.conf"
	fi

	if [! -z "$SERVER_ADMIN_EMAIL" ]
	then
		sed -i "s/example@example.com/$SERVER_ADMIN_EMAIL/g"  "/etc/apache2/sites-available/magento.conf"
	fi

	a2ensite magento.conf

	apache2ctl configtest
	service apache2 restart

	echo "------------------------------------------------------------------"
	echo "    You can install Magento over the Webbrowser now "
	echo " 	  Visit http://localhost        "
	echo "------------------------------------------------------------------"


}

download_magento
install_apache_virtual_host
install_magento