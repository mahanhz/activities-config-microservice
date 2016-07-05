#!/bin/sh

echo "Passed in arguments are: $1, $2"
releaseVersion=$1
semanticVersionUpdate=$2

echo "Release version starting point: $releaseVersion"

major=`echo $releaseVersion | cut -d. -f1`
minor=`echo $releaseVersion | cut -d. -f2`
patch=`echo $releaseVersion | cut -d. -f3`

echo "major=$major, minor=$minor, patch=$patch"

if [ $semanticVersionUpdate = "unchanged" ]; then
	echo "Unchanged"
elif [ $semanticVersionUpdate = "major" ]; then
	major=$((major+1))
	minor=0
	patch=0
elif [ $semanticVersionUpdate = "minor" ]; then
	minor=$((minor+1))
	patch=0
elif [ $semanticVersionUpdate = "patch" ]; then
    patch=$((patch+1))
else
	echo "Invalid semantic version update: $semanticVersionUpdate"
fi

releaseVersion=$major.$minor.$patch

echo "Release version after update: $releaseVersion"

./gradlew release -Prelease.useAutomaticVersion=true -Prelease.releaseVersion=$releaseVersion