#!/bin/bash
set -e

# Extract the version from the current and previous pubspec.yaml
OLD_VERSION=$(git show HEAD^:pubspec.yaml | grep -E '^version:' | awk '{print $2}')
CURRENT_VERSION=$(grep -E '^version:' pubspec.yaml | awk '{print $2}')

echo "Old version: $OLD_VERSION"
echo "Current version: $CURRENT_VERSION"

# Compare versions
if [ "$OLD_VERSION" != "$CURRENT_VERSION" ]; then
  echo "Version changed from $OLD_VERSION to $CURRENT_VERSION"
  echo "VERSION_CHANGED=true" >> $GITHUB_ENV
  echo "OLD_VERSION=$OLD_VERSION" >> $GITHUB_ENV
  echo "NEW_VERSION=$CURRENT_VERSION" >> $GITHUB_ENV

  # Generate changelog if the script exists
  if [ -f ".github/scripts/generate-changelog.sh" ]; then
    bash .github/scripts/generate-changelog.sh "$OLD_VERSION" "$CURRENT_VERSION"
    echo "CHANGELOG_GENERATED=true" >> $GITHUB_ENV
  fi

  exit 0
else
  echo "Version unchanged"
  echo "VERSION_CHANGED=false" >> $GITHUB_ENV
  exit 1
fi