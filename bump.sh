#!/bin/bash

NOW="$(date +'%B %d, %Y')"
RED="\033[1;31m"
GREEN="\033[0;32m"
YELLOW="\033[1;33m"
BLUE="\033[1;34m"
PURPLE="\033[1;35m"
CYAN="\033[1;36m"
WHITE="\033[1;37m"
RESET="\033[0m"

LATEST_HASH=`git log --pretty=format:'%h' -n 1`

QUESTION_FLAG="${GREEN}?"
WARNING_FLAG="${YELLOW}!"
NOTICE_FLAG="${CYAN}❯"

# $1 : version
# $2 : release note
function tag {
  if [ -z "$2" ]; then
    # Default release note
    git tag -a "v$1" -m "Tag version $1."
  else
    # Custom release note
    git tag -a "v$1" -m "$2"
  fi
}

if [ -f VERSION ]; then
    BASE_STRING=`cat VERSION`
    BASE_LIST=(`echo $BASE_STRING | tr '.' ' '`)
    V_MAJOR=${BASE_LIST[0]}
    V_MINOR=${BASE_LIST[1]}
    V_PATCH=${BASE_LIST[2]}
    echo -e "${NOTICE_FLAG} Current version: ${WHITE}$BASE_STRING"
    echo -e "${NOTICE_FLAG} Latest commit hash: ${WHITE}$LATEST_HASH"
    V_PATCH=$((V_PATCH + 1))
    SUGGESTED_VERSION="$V_MAJOR.$V_MINOR.$V_PATCH"
    echo -ne "${QUESTION_FLAG} ${CYAN}Enter a version number [${WHITE}$SUGGESTED_VERSION${CYAN}]: "
    read INPUT_STRING
    if [ "$INPUT_STRING" = "" ]; then
        INPUT_STRING=$SUGGESTED_VERSION
    fi
    # Check if your current source is not already tagged by using current hash
    GIT_COMMIT=`git rev-parse HEAD`
    NEEDS_TAG=`git describe --contains $GIT_COMMIT`
    # Only tag if no tag already (would be better if the git describe command above could have a silent option)
    if [ -n "$NEEDS_TAG" ]; then
        echo -e "${WARNING_FLAG} Current code is already released."
        exit 0
    fi
    echo -e "${NOTICE_FLAG} Will set new version to be ${WHITE}$INPUT_STRING"
    echo $INPUT_STRING > VERSION
    echo "## $INPUT_STRING ($NOW)" > tmpfile
    git log --pretty=format:"  - %s" "v$BASE_STRING"...HEAD >> tmpfile
    echo "" >> tmpfile
    cat CHANGELOG.md >> tmpfile
    mv tmpfile CHANGELOG.md
    git add CHANGELOG.md VERSION
    git commit -m "Release ${INPUT_STRING}"
    tag "${INPUT_STRING}"
else
    echo -e "${WARNING_FLAG} Could not find a VERSION file."
    echo -ne "${QUESTION_FLAG} ${CYAN}Do you want to create a version file and start from scratch? [${WHITE}y${CYAN}]: "
    read RESPONSE
    if [ "$RESPONSE" = "" ]; then RESPONSE="y"; fi
    if [ "$RESPONSE" = "Y" ]; then RESPONSE="y"; fi
    if [ "$RESPONSE" = "Yes" ]; then RESPONSE="y"; fi
    if [ "$RESPONSE" = "yes" ]; then RESPONSE="y"; fi
    if [ "$RESPONSE" = "YES" ]; then RESPONSE="y"; fi
    if [ "$RESPONSE" = "y" ]; then
        echo "1.0.0" > VERSION
        echo "## 1.0.0 ($NOW)" > CHANGELOG.md
        git log --pretty=format:"  - %s" >> CHANGELOG.md
        echo "" >> CHANGELOG.md
        git add VERSION CHANGELOG.md
        git commit -m "Release v1.0.0"
        tag "1.0.0"
    fi
fi

echo -e "${NOTICE_FLAG} Finished."
