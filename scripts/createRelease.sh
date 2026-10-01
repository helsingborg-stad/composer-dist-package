#!/bin/sh

set -eu

REPO="${1}"
TAG="${2}"
TOKEN="${2}"

curl -L \
  -X POST \
  -H "Accept: application/vnd.github+json" \
  -H "Authorization: Bearer $TOKEN" \
  -H "X-GitHub-Api-Version: 2026-03-10" \
  https://api.github.com/repos/$REPO/releases \
  -d '{"tag_name":"$TAG","target_commitish":"main","name":"TAG","body":"","draft":false,"prerelease":false,"generate_release_notes":false}'