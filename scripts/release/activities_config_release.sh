#!/bin/sh

echo "Passed in arguments are: $1, $2"
export VERSION=$1
export RELEASE_TYPE=$2

major=`echo $VERSION | cut -d. -f1`
minor=`echo $VERSION | cut -d. -f2`
patch=`echo $VERSION | cut -d. -f3`

echo "major=$major, minor=$minor, patch=$patch"

if [ "$RELEASE_TYPE" == "patch" ]; then
	((patch++))
elif [ "$RELEASE_TYPE" == "minor" ]; then
	((minor++))
	patch=0
elif [ "$RELEASE_TYPE" == "major" ]; then
	((major++))
	minor=0
	patch=0
else
	echo "Invalid release type"
fi

versionToRelease=$major.$minor.$patch

echo "releaseVersion=$versionToRelease"

./gradlew release -Prelease.useAutomaticVersion=true -Prelease.releaseVersion=$versionToRelease -Prelease.newVersion=$versionToRelease