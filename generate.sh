#!/bin/sh
PREFIX=$1

initial_version="0.0.1"
last_version=$(git describe --tags $(git rev-list --tags --max-count=1) | sed 's/[A-Za-z]*//g')
major="$(cut -d'.' -f1 <<<$last_version)"
minor="$(cut -d'.' -f2 <<<$last_version)"
patch="$(cut -d'.' -f3 <<<$last_version)"

next_version=""
commit_msg=$(git log -1 --pretty=%B)
major_comment=":breaking:"
minor_comment="feature:"

if [ -z $major ] && [ -z $minor ] && [ -z $patch ]; then
    next_version=$initial_version
else
    if [[ $commit_msg == *$major_comment* ]]; then
        major=$(($major+1))
    elif [[ $commit_msg == *$minor_comment* ]]; then
        minor=$(($minor+1))
    else
        patch=$(($patch+1))
    fi
    next_version="$major.$minor.$patch"
fi

printf "$PREFIX$next_version"
