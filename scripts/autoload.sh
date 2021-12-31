#!/bin/bash
file="public/wp-config.php"
pwd=`pwd`
# if  sed --version succceds then this is probably a linux system
if sed --version >/dev/null 2>&1; then
sed -i '/\/\* That'\''s all, stop editing\! Happy publishing\. \*\//a\
\
require_once FORME_PRIVATE_ROOT.'"'"'/vendor/autoload.php'"'"';\
' $file
# otherwise this is probably a mac, we need to add '' because of ancient sed
else
sed -i '' '/\/\* That'\''s all, stop editing\! Happy publishing\. \*\//a\
\
require_once FORME_PRIVATE_ROOT.'"'"'/vendor/autoload.php'"'"';\
' $file
fi
echo "Success: Require autoload"
