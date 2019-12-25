#!/bin/bash

# This script is intended to be sourced by another

# If branch is master, we push to felipecassiors/ubuntu1804-4dev, else to felipecassiors/ubuntu1804-4dev-dev
if [ "$TRAVIS_BRANCH" == master ]; then
  echo "Running upon master branch"

  readonly BASE_URL="https://app.vagrantup.com/api/v1/box/felipecassiors/ubuntu1804-4dev"

  echo "Fetching tags..."
  git tag | xargs git tag -d > /dev/null
  git fetch --tags > /dev/null

  if git describe --contains &> /dev/null; then # Test if current commit is already tagged
    echo "Running upon a tagged commit"
    readonly SHOULD_PUSH_TAGS=false
    GIT_TAG="$(git tag --points-at)"
    readonly VERSION=${GIT_TAG#v*}
  else
    echo "Running upon a untagged commit, bumping patch number and tagging it..."
    readonly SHOULD_PUSH_TAGS=true
    GIT_TAG=$(bump patch --dry-run)
    readonly VERSION=${GIT_TAG#v*}
    git config user.email "travis@travis-ci.org"
    git config user.name "Travis CI"
    readonly TAG_MESSAGE="$(cat <<-_EOT_
      Version $VERSION
      Available on https://app.vagrantup.com/felipecassiors/boxes/ubuntu1804-4dev/versions/$VERSION
      Built by Travis on $TRAVIS_BUILD_WEB_URL
      _EOT_
      )"
    git tag -a "$GIT_TAG" -m "$TAG_MESSAGE" > /dev/null
  fi
  
  echo "Generating changelog..."
  readonly LATEST_TAG="$(git tag | sort -r --version-sort | head -1)"
  readonly SECOND_LATEST_TAG="$(git tag | sort -r --version-sort | head -2 | awk '{split($0, tags, "\n")} END {print tags[1]}')"
  readonly DESCRIPTION="$(cat <<-_EOT_
    ## Changelog
    "$(git log "$SECOND_LATEST_TAG"..."$LATEST_TAG"  --pretty=format:"- [%h](http://github.com/felipecassiors/ubuntu1804-4dev/commit/%H) %s")"
    
    [**Built by Travis**]($TRAVIS_BUILD_WEB_URL)
    [**View source code in GitHub**](https://github.com/felipecassiors/ubuntu1804-4dev/tree/$GIT_TAG)"
    _EOT_
    )"

else
  echo "Running upon a branch other than master"
  BASE_URL="https://app.vagrantup.com/api/v1/box/felipecassiors/ubuntu1804-4dev-dev"
  VERSION="$(date +'%Y%m.%d.%H%M')"
  DESCRIPTION="[**View source code in GitHub**](https://github.com/felipecassiors/ubuntu1804-4dev/commit/"$(git rev-parse HEAD)")"
fi

VERSION_BASE_URL="$BASE_URL/version/$VERSION"
PROVIDER="virtualbox"
PROVIDER_BASE_URL="$VERSION_BASE_URL/provider/$PROVIDER"
FILE="package.box"
