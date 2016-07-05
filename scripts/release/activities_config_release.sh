#!/bin/sh

echo "Passed in arguments are: $1, $2"
version=$1
semanticVersionUpdate=$2

echo "New version starting point: $version"

major=`echo $version | cut -d. -f1`
minor=`echo $version | cut -d. -f2`
patch=`echo $version | cut -d. -f3`

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

version=$major.$minor.$patch

echo "New version after update: $version"

./gradlew release -Prelease.useAutomaticVersion=true -Prelease.releaseVersion=$version