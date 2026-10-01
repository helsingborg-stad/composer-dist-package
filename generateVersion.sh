#!/bin/bash

# Rules for generating semantic versioning
# major: breaking change
# minor: feat, style
# patch: build, fix, perf, refactor, revert

echo "Generate version: $GENERATE_VERSION"

LAST_TAG=$(git describe --tags --abbrev=0 --always)
echo "Last tag: #$LAST_TAG#"
PATTERN="^[0-9]+\.[0-9]+\.[0-9]+$"

increment_version() {
    local version=$1
    local increment=$2
    local major=$(echo $version | cut -d. -f1)
    local minor=$(echo $version | cut -d. -f2)
    local patch=$(echo $version | cut -d. -f3)

    if [ "$increment" == "major" ]; then
        major=$((major + 1))
        minor=0
        patch=0
    elif [ "$increment" == "minor" ]; then
        minor=$((minor + 1))
        patch=0
    elif [ "$increment" == "patch" ]; then
        patch=$((patch + 1))
    fi

    echo "${major}.${minor}.${patch}"
}

create_file() {
    git log $LAST_TAG..HEAD --no-decorate --pretty=format:"%s" > messages.txt
}

get_commit_range() {
    if [[ $LAST_TAG =~ $PATTERN ]]; then
        create_file true
    else
        create_file
        LAST_TAG="0.0.0"
    fi
    echo " " >> messages.txt
}

remove_file() {
    rm -f messages.txt
}

start() {
    get_commit_range
    new_version=$LAST_TAG
    increment_type=""

    while read message; do
        if [[ $message =~ (([a-z]+)(\(.+\))?\!:)|(BREAKING CHANGE:) ]]; then
            increment_type="major"
            break
        elif [[ $message =~ (^(feat|style)(\(.+\))?:) ]]; then
            if [ -z "$increment_type" ] || [ "$increment_type" == "patch" ]; then
                increment_type="minor"
            fi
        elif [[ $message =~ ^((fix|build|perf|refactor|revert|chore)(\(.+\))?:) ]]; then
            if [ -z "$increment_type" ]; then
                increment_type="patch"
            fi
        fi
    done < messages.txt

    if [ -n "$increment_type" ]; then
        new_version=$(increment_version $LAST_TAG $increment_type)
        echo "New version: $new_version"
        remove_file
        exit 1
    else
        echo "No changes requiring a version increment."
        remove_file
        exit 0
    fi
}

start