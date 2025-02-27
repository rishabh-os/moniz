#!/bin/bash
set -e

# Get the old and new version from the environment
OLD_VERSION=$1
NEW_VERSION=$2

# Create a temporary file for the changelog
CHANGELOG_FILE="CHANGELOG_GENERATED.md"

echo "# Changelog for version $NEW_VERSION" > $CHANGELOG_FILE
echo "" >> $CHANGELOG_FILE
echo "## What's Changed" >> $CHANGELOG_FILE
echo "" >> $CHANGELOG_FILE

# Find the commit that last changed the version number
LAST_VERSION_COMMIT=$(git log -p --format="%H" -- pubspec.yaml | grep -B 5 "version: $OLD_VERSION" | head -n 1 || echo "")

if [ -z "$LAST_VERSION_COMMIT" ]; then
  # If we can't find the exact commit, just use the range since the previous commit
  echo "Could not find exact commit for previous version. Using recent history."
  git log --pretty=format:"* %s (%h)" -n 20 >> $CHANGELOG_FILE
else
  # Get all commits between the last version change and now
  git log --pretty=format:"* %s (%h)" $LAST_VERSION_COMMIT..HEAD >> $CHANGELOG_FILE
fi

echo "Generated changelog for version $NEW_VERSION"
cat $CHANGELOG_FILE