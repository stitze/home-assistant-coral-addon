#!/usr/bin/env bash

CONFIG_FILE="config.json"
CURRENT_VERSION=$(grep -oP '"version":\s*"\K[0-9.]+' "$CONFIG_FILE")

IFS='.' read -r major minor patch <<< "$CURRENT_VERSION"
NEW_PATCH=$((patch + 1))
NEW_VERSION="$major.$minor.$NEW_PATCH"

sed -i "s/\"version\": \"$CURRENT_VERSION\"/\"version\": \"$NEW_VERSION\"/" "$CONFIG_FILE"
git add "$CONFIG_FILE"