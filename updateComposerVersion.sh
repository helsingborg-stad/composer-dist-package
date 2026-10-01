#!/bin/sh

# Upserts composer dist property to point to a specified github release artifact

set -eu

FILE=composer.json

DIST_REFERENCE="${1}"
DIST_TYPE="zip"
DIST_FILE_NAME="${3:-dist.zip}"
GITHUB_REPO="helsingborg-stad/composer-dist-package"
DIST_URL="https://github.com/${GITHUB_REPO}/releases/download/${DIST_REFERENCE}/${DIST_FILE_NAME}"

tmp="${FILE}.tmp.$$"

jq \
  --arg type "$DIST_TYPE" \
  --arg url "$DIST_URL" \
  --arg reference "$DIST_REFERENCE" \
  '
  .dist = {
    type: $type,
    url: $url
  }
  + (if $reference != "" then {reference: $reference} else {} end)
  ' \
  "$FILE" > "$tmp"

mv "$tmp" "$FILE"