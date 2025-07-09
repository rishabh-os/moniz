#!/bin/bash
set -e
# Get the latest release tag (assuming tags are in the form vX.Y.Z)
LATEST_TAG=$(git describe --tags --abbrev=0)

# Extract the version from the pubspec.yaml at the latest tag
OLD_VERSION=$(git show ${LATEST_TAG}:pubspec.yaml | grep -E '^version:' | awk '{print $2}')
CURRENT_VERSION=$(grep -E '^version:' pubspec.yaml | awk '{print $2}')

echo "Old version: $OLD_VERSION"
echo "Current version: $CURRENT_VERSION"

# Compare versions
if [ "$OLD_VERSION" != "$CURRENT_VERSION" ]; then
  echo "Version changed from $OLD_VERSION to $CURRENT_VERSION"
  echo "VERSION_CHANGED=true" >> $GITHUB_ENV
  echo "OLD_VERSION=$OLD_VERSION" >> $GITHUB_ENV
  echo "NEW_VERSION=$CURRENT_VERSION" >> $GITHUB_ENV

  bash .github/scripts/generate_changelog.sh "$OLD_VERSION" "$CURRENT_VERSION"
  echo "CHANGELOG_GENERATED=true" >> $GITHUB_ENV

  exit 0
else
  echo "Version unchanged"
  echo "VERSION_CHANGED=false" >> $GITHUB_ENV
  exit 1
fi