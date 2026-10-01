#!/bin/sh

set -eu

VERSION_CONFIG=versionConfig.json
GENERATED_VERSION=$(bash ./scripts/generateVersion.sh)
CONFIG_COMPOSER_FILE=$(jq -r '.composerFile // "composer.json"' $VERSION_CONFIG)
CONFIG_COMPOSER_DIST_TYPE=$(jq -r '.composerDistType // "zip"' $VERSION_CONFIG)
CONFIG_COMPOSER_DIST_FILE_NAME=$(jq -r '.composerDistFileName // "dist.zip"' $VERSION_CONFIG)
CONFIG_COMPOSER_DIST_GITHUB_REPO=$(jq -r '.composerDistGithubRepo // empty' $VERSION_CONFIG)

if git status --porcelain -- $CONFIG_COMPOSER_FILE | grep -q .; then
    echo "commit or stash changes to $CONFIG_COMPOSER_FILE before running version update."
    exit
fi

bash ./scripts/updateComposerVersion.sh \
    $CONFIG_COMPOSER_FILE \
    $GENERATED_VERSION \
    $CONFIG_COMPOSER_DIST_TYPE \
    $CONFIG_COMPOSER_DIST_FILE_NAME \
    $CONFIG_COMPOSER_DIST_GITHUB_REPO

git add $CONFIG_COMPOSER_FILE
git commit --quiet -m "release: $GENERATED_VERSION"
git tag $GENERATED_VERSION