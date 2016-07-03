#!groovy

COMMIT_ID = ""
APP_VERSION = ""

node {
stage 'Version'
APP_VERSION = readFile('gradle.properties')
echo "2 - The current version is: " + APP_VERSION.substring(APP_VERSION.lastIndexOf("="))
}
