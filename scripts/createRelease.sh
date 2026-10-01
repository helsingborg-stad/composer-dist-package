#!/bin/sh

set -eu

REPO="${1}"
TAG="${2}"
TOKEN="${3}"

curl -L \
  -X POST \
  -H "Accept: application/vnd.github+json" \
  -H "Authorization: Bearer $TOKEN" \
  -H "X-GitHub-Api-Version: 2026-03-10" \
  https://api.github.com/repos/$REPO/releases \
  -d "$(jq -n \
  --arg tag "$TAG" \
  '{
    tag_name: $tag,
    target_commitish: "main",
    name: $tag,
    body: "",
    draft: false,
    prerelease: false,
    generate_release_notes: false
  }')" > /dev/null