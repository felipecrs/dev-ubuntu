#!/bin/bash

(
  echo "Testing the deployed box..." && \
  set -x && \
  echo "  Fetching download url..." && \
  readonly DOWNLOAD_URL=$(curl -fsS \
    --header "Authorization: Bearer $VAGRANT_CLOUD_TOKEN" \
    "$PROVIDER_BASE_URL" \
    | jq -r .download_url) && \

  echo "  Adding box to vagrant..." && \
  readonly TEST_BOX="test-deploy" && \
  vagrant box add "$TEST_BOX" "$DOWNLOAD_URL" && \

  echo "  Performing vagrant init and up..." && \
  readonly TEST_FOLDER="temp/" && \
  ( rmdir "$TEST_FOLDER" &> /dev/null; mkdir "$TEST_FOLDER" ) && \
  pushd "$TEST_FOLDER" > /dev/null && \
  vagrant init "$TEST_BOX" && \
  vagrant up && \
  popd > /dev/null
)
