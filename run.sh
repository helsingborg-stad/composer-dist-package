#!/bin/sh

set -eu

GENERATED_VERSION=$(bash ./scripts/generateVersion.sh)
echo "✔ new version is $GENERATED_VERSION"

VERSION_CONFIG=versionConfig.json
CONFIG_COMPOSER_FILE=$(jq -r '.composerFile // "composer.json"' $VERSION_CONFIG)
CONFIG_COMPOSER_DIST_TYPE=$(jq -r '.composerDistType // "zip"' $VERSION_CONFIG)
CONFIG_COMPOSER_DIST_FILE_NAME=$(jq -r '.composerDistFileName // "dist.zip"' $VERSION_CONFIG)
CONFIG_COMPOSER_DIST_GITHUB_REPO=$(jq -r '.composerDistGithubRepo // empty' $VERSION_CONFIG)

if git status --porcelain -- $CONFIG_COMPOSER_FILE | grep -q .; then
    echo "⚠ commit or stash changes to $CONFIG_COMPOSER_FILE before running version update."
    exit
fi

bash ./scripts/updateComposerVersion.sh \
    $CONFIG_COMPOSER_FILE \
    $GENERATED_VERSION \
    $CONFIG_COMPOSER_DIST_TYPE \
    $CONFIG_COMPOSER_DIST_FILE_NAME \
    $CONFIG_COMPOSER_DIST_GITHUB_REPO

echo "✔ $CONFIG_COMPOSER_FILE dist information updated"

git add $CONFIG_COMPOSER_FILE
git commit --quiet -m "release: $GENERATED_VERSION"
echo "✔ git commit 'release: $GENERATED_VERSION'"
git tag $GENERATED_VERSION
echo "✔ git tag $GENERATED_VERSION"
git push --quiet
echo "✔ git push"
git push --quiet --tags
echo "✔ git push --tags"

bash ./scripts/updateComposerVersion.sh \
    $CONFIG_COMPOSER_DIST_GITHUB_REPO \
    $GENERATED_VERSION \
    $GH_TOKEN 
