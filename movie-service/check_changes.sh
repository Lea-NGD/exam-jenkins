#!/bin/bash

CHANGED_FILES=$(git diff --name-only $GIT_PREVIOUS_COMMIT $GIT_COMMIT)

if echo "$CHANGED_FILES" | grep -q "^movie-service/"; then
    exit 0
else
    exit 1
fi