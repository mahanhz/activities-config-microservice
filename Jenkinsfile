#!groovy

COMMIT_ID = ""
APP_VERSION = ""

node {
stage 'Version'
echo "1 - The current version is: " + Aversion()

APP_VERSION = readFile('gradle.properties')
echo "2 - The current version is: " + APP_VERSION.substring(APP_VERSION.lastIndexOf("="))
}

def version() {
    def version = readFile('gradle.properties')
    version.substring(version.lastIndexOf("="))
}