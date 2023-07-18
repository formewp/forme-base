#!/bin/bash
WGET_EXISTS='command -v wget'
CURL_EXISTS='command -v curl'
WPCLI_EXISTS='command -v wp'
if ! $WGET_EXISTS &> /dev/null && ! $CURL_EXISTS &> /dev/null && ! $WPCLI_EXISTS &> /dev/null
then
echo "You need to install wp-cli, wget or curl to use the install script"
exit 0
fi
if $WPCLI_EXISTS &> /dev/null
then
if [ "$CI" = true ]; then
  # Add --allow-root flag
  wp core download --path=public --allow-root
else
  wp core download --path=public
fi
exit 0
fi
echo "Downloading latest version of WordPress from github"
# check if wget
if $WGET_EXISTS &> /dev/null
then
wget -q --no-check-certificate --content-disposition https://github.com/johnpbloch/wordpress-core/archive/refs/heads/master.zip
fi
# check if not wget but curl
if ! $WGET_EXISTS &> /dev/null && $CURL_EXISTS &> /dev/null
then
curl -sLJO https://github.com/johnpbloch/wordpress-core/archive/refs/heads/master.zip
fi
echo "Installing WordPress into public directory"
# unzip that thing
unzip -q -d "public" "wordpress-core-master.zip" && f=("public"/*) && mv "public"/*/* "public" && rmdir "${f[@]}"
# remove the file
echo "Tidying up"
rm wordpress-core-master.zip
echo "Success: WordPress Downloaded."
