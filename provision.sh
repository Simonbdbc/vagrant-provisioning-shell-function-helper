#!/usr/bin/env bash

exe () {
    MESSAGE_PREFIX="\b\b\b\b\b\b\b\b\b\b"
    echo -e "$MESSAGE_PREFIX Execute: $1"
    LOOP=0
    while true;
    do
        if ! [ $LOOP == 0 ]; then echo -e "$MESSAGE_PREFIX ...     "; fi;
        sleep 3;
        LOOP=$((LOOP+1))
    done & ERROR=$("${@:2}" 2>&1)
    status=$?
    kill $!; trap 'kill $!' SIGTERM

    if [ $status -ne 0 ];
    then
        echo -e "$MESSAGE_PREFIX ✖ Error" >&2
        echo -e "$ERROR" >&2
    else
        echo -e "$MESSAGE_PREFIX ✔ Success"
    fi
    return $status
}

## Examples

exe 'Update apt indexes' \
    sudo apt-gete update

exe 'Install git, php7.0-mbstring & php7.0-zip' \
    sudo apt-get install -y git php7.0-mbstring php7.0-zip

exe 'Disable default vhost' \
    sudo a2dissite 000-default

exe 'Change apache user to vagrant' \
    sudo sed -i 's/www-data/vagrant/g' /etc/apache2/envvars

exe 'Make apache ssl directory' \
    sudo mkdir -p /etc/apache2/ssl

exe 'Create self-signed certificate' \
    sudo openssl req -x509 -nodes -days 365 -newkey rsa:2048 -keyout /etc/apache2/ssl/apache.key -out \
    /etc/apache2/ssl/apache.crt -subj \
    '/C=GB/ST=Location/L=Location/O=Company/OU=IT Department/CN=example.tld'

exe 'Restart Apache' \
    sudo service apache2 restart
