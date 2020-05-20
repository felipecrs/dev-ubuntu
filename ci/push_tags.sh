#!/bin/bash

if [ "$should_push_tags" = true ]; then
	echo "Pushing tag to GitHub..."
	git remote add origin-tags "https://${GITHUB_TOKEN}@github.com/felipecassiors/dev-ubuntu-20.04.git"
	# Force is to replace the tag on remote if it already exists
	git push origin-tags --tags --force
fi
