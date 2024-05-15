#!/bin/sh
git filter-branch --env-filter '
OLD_EMAIL="h12345jack@gmail.com"
CORRECT_NAME="hotchilipowder"
CORRECT_EMAIL="h12345jack@gmail.com"
if [ "$GIT_COMMITTER_NAME" = "$OLD_EMAIL" ]
then
    export GIT_COMMITTER_NAME="$CORRECT_NAME"
    export GIT_COMMITTER_EMAIL="$CORRECT_EMAIL"
fi
if [ "$GIT_AUTHOR_EMAIL" = "$OLD_EMAIL" ]
then
    export GIT_AUTHOR_NAME="$CORRECT_NAME"
    export GIT_AUTHOR_EMAIL="$CORRECT_EMAIL"
fi
' --tag-name-filter cat -- --branches --tags
