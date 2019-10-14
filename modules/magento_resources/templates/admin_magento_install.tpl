#!/bin/bash

set -x

RESTORE_FROM_BACKUP=false 

exec > >(tee /var/log/user-data.log|logger -t user-data -s 2>/dev/console) 2>&1

sudo apt-get update

sudo apt-get install -y libffi-dev g++ libssl-dev python-pip python-dev git nfs-common

sudo apt-get install mysql-server 

pip install -U awscli ansible setuptools

aws s3 cp s3://readonly-key/id_rsa /tmp/readkey.pem 

chmod 0400 /tmp/readkey.pem 

mkdir -p /var/www/magento

echo "${SHARED_MOUNT}:/ /var/www/magento nfs4 nfsvers=4.1,rsize=1048576,wsize=1048576,hard,timeo=600,retrans=2,_netdev 0 0" >> /etc/fstab

mount -a

chown www-data:www-data /var/www/magento

chmod 0775 /var/www/magento

usermod -a -G www-data ubuntu

mkdir -p /home/ubuntu/ansible

ssh-keyscan gitlab.com >> /root/.ssh/known_hosts

ssh-agent bash -c 'ssh-add /tmp/readkey.pem; git clone git@bitbucket.org:faisalna/infra-code.git /home/ubuntu/ansible'

chown -R ubuntu:ubuntu /home/ubuntu

touch /var/www/test_file_for_me_enjoy 

mysql -h ${MAGENTO_DATABASE_HOST} -u ${MAGENTO_DATABASE_USER} -p${MAGENTO_DATABASE_PASSWORD} ${MAGENTO_DATABASE_NAME} < /home/ununtu/ansible/modules/magento_resources/sanitise/sanitise.sql


# Due to Time It Takes Lets Try Restoring DB from Backup
# Remove Snapshot Variable  from Module 
if [ ${BACKUP_FROM_BACKUP} != "false" ]; then 
 
  ../restore_bkup/restore.sh ${MAGENTO_DATABASE_NAME}
  
fi 

sed "s/{{{ENVIRONMENT_NAME}}/${ENVIRONMENT_NAME}/" /home/ununtu/ansible/modules/magento_resources/sanitise/sanitise.sql  | mysql -h ${MAGENTO_DATABASE_HOST} -u ${MAGENTO_DATABASE_USER} -p${MAGENTO_DATABASE_PASSWORD} ${MAGENTO_DATABASE_NAME} 

 
# mysql -h ${MAGENTO_DATABASE_HOST} -u ${MAGENTO_DATABASE_USER} -p${MAGENTO_DATABASE_PASSWORD} ${MAGENTO_DATABASE_NAME} < /home/ununtu/ansible/modules/magento_resources/sanitise/set_env.sql

sudo -u ubuntu ansible-playbook -i 'localhost,' /home/ubuntu/ansible/playbooks/autoscale.yaml 


# Lets Download the Code Repo Master Branch 

git clone git@bitbucket.org:mini_exchange/miniexchange_magento2.git /var/www/magento/


chown -Rf www-data:www-data /var/www/magento

# To Find the correct file 
sudo -u www-data cp /var/www/magento-last-working/app/etc/config.php  /var/www/magento/app/etc/config.php

unzip /home/ununtu/ansible/modules/magento_resources/environment/nginx.zip 

cp -rf /home/ununtu/ansible/modules/magento_resources/environment/nginx /etc/nginx 
 
sed "s/{{ENVIRONMENT_NAME}}/${ENVIRONMENT_NAME}/" /home/ununtu/ansible/modules/magento_resources/environment/maps.test.conf > /etc/nginx/includes/magento/maps.test.conf.new 

mv /etc/nginx/includes/magento/maps.test.conf.new /etc/nginx/includes/magento/maps.test.conf 

sed "s/db-restored.internal.sprii.com/${MAGENTO_DATABASE_HOST}/" /home/ununtu/ansible/modules/magento_resources/environment/env.php  > /tmp/env.php 

sed "s/redissession.nwoalm.0001.euw1.cache.amazonaws.com/${MAGENTO_REDIS_CACHE_HOST_NAME}/" /tmp/env.php  > /tmp/env.php.final

sudo -u www-data cp /tmp/env.php.final  /var/www/magento/app/etc/env.php

cd /var/www/magento

sudo -u www-data n98-magerun2.phar setup:upgrade

sudo -u www-data n98-magerun2.phar module:enable --all --clear-static-content

sudo -u www-data n98-magerun2.phar setup:static-content:deploy --jobs 10  --theme  Miniexchange/sprii --theme Magento/backend -v --no-interaction --ansi --language en_US

sudo -u www-data n98-magerun2.phar setup:static-content:deploy --jobs 10  --theme  Miniexchange/sprii --theme Magento/backend -v --no-interaction --ansi --language ar_SA

sudo -u www-data n98-magerun2.phar  setup:di:compile -v --no-interaction --ansi

chown -Rf www-data:www-data /var/www/magento

sudo /etc/init.d/nginx restart 

