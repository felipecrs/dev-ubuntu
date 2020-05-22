#!/usr/bin/env bash

curl -X POST https://api.github.com/repos/felipecassiors/dev-ubuntu-20.04/dispatches \
	-H 'Authorization: token $TOKEN' \
	--data '{"event_type": "manual_trigger"}'
