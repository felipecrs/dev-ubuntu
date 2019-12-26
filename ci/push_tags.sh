#!/bin/bash

if [ "$SHOULD_PUSH_TAGS" = true ]; then
	echo "Pushing tag to GitHub..."
	git remote add origin-tags "https://${GITHUB_TOKEN}@github.com/felipecassiors/ubuntu1804-4dev.git"
	# Force is to replace the tag on remote if it already exists
	git push origin-tags --tags --force
fi
