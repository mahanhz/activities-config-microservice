#!/bin/sh

echo "Passed in arguments are: $1, $2"
versionToRelease=$1
semanticVersionUpdate=$2
snapshotSuffix="-SNAPSHOT"

echo "Release version before semantic update: $versionToRelease"

major=`echo $versionToRelease | cut -d. -f1`
minor=`echo $versionToRelease | cut -d. -f2`
patch=`echo $versionToRelease | cut -d. -f3`

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

versionToRelease=$major.$minor.$patch
nextVersion=$major.$minor.$((patch+1))$snapshotSuffix

echo "Release version after semantic update: $versionToRelease"
echo "Next version: $nextVersion"

./gradlew release -Prelease.useAutomaticVersion=true -Prelease.releaseVersion=$versionToRelease -Prelease.newVersion=$nextVersion