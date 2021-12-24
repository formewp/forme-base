#!/bin/bash
# this generates a version of our composer file with all the scripts inlined
# it's fairly naive, just search and replace with sed and some judicious escaping
# if you add any scripts you'll need to configure them below
# requires jq to wrangle the json (brew install jq)
JQ_EXISTS='command -v jq'
if ! $JQ_EXISTS &> /dev/null
then
echo "You need to install jq globally to run the inlining script"
exit 0
fi
COMPOSER_FILE="utils/composer.json"
# copy the file
cp composer.json $COMPOSER_FILE

function inline_script() {
    NEW_CONTENT=`cat $1 | jq -aRs .`
    ESCAPED_CONTENT=$(printf '%s\n' "$NEW_CONTENT" | sed -e 's/[\/&]/\\&/g')
    ESCAPED_FILE=$(printf '%s\n' "$1" | sed -e 's/[\/&]/\\&/g')
    sed -i '' "s/\"$ESCAPED_FILE\"/$ESCAPED_CONTENT/g" $COMPOSER_FILE
}
# replace install
inline_script "scripts/install.sh"
# replace config
inline_script "scripts/config.sh"
# replace autoload
inline_script "scripts/autoload.sh"
# replace cp .env
CP_COMMAND="cp .env.example .env"
ESCAPED_COMMAND=$(printf '%s\n' "$CP_COMMAND" | sed -e 's/[\/&]/\\&/g')
ENV_EXAMPLE=`cat .env.example`
NEW_CONTENT=$(echo "touch .env && echo \"$ENV_EXAMPLE\" >> .env" | jq -aRs .)
ESCAPED_CONTENT=$(printf '%s\n' "$NEW_CONTENT" | sed -e 's/[\/&]/\\&/g')
sed -i '' "s/\"$ESCAPED_COMMAND\"/$ESCAPED_CONTENT/g" $COMPOSER_FILE
