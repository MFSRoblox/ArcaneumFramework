#!/usr/bin/env bash
#https://github.com/vocksel/flipbook/blob/main/.github/workflows/validate-secret.sh
if [[ -z $2 ]]; then
	echo "Could not find a secret named $1"
	echo "Please set a repository secret named '$1' with"
	exit 1
else
	echo "Found $1 secret. Continuing..."
fi