#!/bin/bash


bash install_lamp.sh
bash install_magento.sh
bash install_firewall.sh

if [ $1 == "-ssl=1" ] 
then
    bash enable_ssl.sh
fi

