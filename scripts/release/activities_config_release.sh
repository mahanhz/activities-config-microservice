#!/bin/sh

echo "Passed in arguments are: $1, $2"
version=$1
semanticVersionSegment=$2

echo "current version=$version, semanticVersionSegment=$semanticVersionSegment"

major=`echo $version | cut -d. -f1`
minor=`echo $version | cut -d. -f2`
patch=`echo $version | cut -d. -f3`

echo "major=$major, minor=$minor, patch=$patch"

if [ $semanticVersionSegment = "patch" ]; then
	((patch++))
elif [ $semanticVersionSegment = "minor" ]; then
	((minor++))
	patch=0
elif [ $semanticVersionSegment = "major" ]; then
	((major++))
	minor=0
	patch=0
else
	echo "Invalid semantic version segment: $semanticVersionSegment"
fi

version=$major.$minor.$patch

echo "new version=$version"

./gradlew release -Prelease.useAutomaticVersion=true -Prelease.releaseVersion=$version -Prelease.newVersion=$version