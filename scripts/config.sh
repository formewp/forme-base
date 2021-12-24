#!/bin/bash
WPCLI_EXISTS='command -v wp'
if ! $WPCLI_EXISTS &> /dev/null
then
echo "You need to install wp-cli globally to run the configuration script"
exit 0
fi
wp config create --prompt=dbname,dbuser,dbpass --skip-check --path=public
wp config set WP_ENV development --path=public
pwd=`pwd`
wp config set FORME_PRIVATE_ROOT $(pwd)"/" --path=public
echo "Check public/wp-config.php to make sure all correct"
