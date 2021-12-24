#!/bin/bash
file="public/wp-config.php"
pwd=`pwd`
sed -i '' '/\/\* That'\''s all, stop editing\! Happy publishing\. \*\//a\
\
require_once '"'$pwd"'/vendor/autoload.php'"'"';\
' $file
echo "Success: Require autoload"
