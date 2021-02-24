#!/bin/sh

set -u

DEFAULT_POLL_TIMEOUT=10
POLL_TIMEOUT=${POLL_TIMEOUT:-$DEFAULT_POLL_TIMEOUT}

git checkout "${GITHUB_REF:11}"

branch=${GITHUB_REPOSITORY}/$(git symbolic-ref --short HEAD)

sh -c "git config --global credential.username $GITLAB_USERNAME"
sh -c "git config --global core.askPass /cred-helper.sh"
sh -c "git config --global credential.helper cache"
sh -c "git remote add mirror $*"
sh -c "echo pushing to $branch branch at $(git remote get-url --push mirror)"
sh -c "git push mirror $branch"

sleep $POLL_TIMEOUT

# convert slashes in a HTML-compatible way
branch=${branch//\//%2F}

echo "Done pushing to Gitlab"
