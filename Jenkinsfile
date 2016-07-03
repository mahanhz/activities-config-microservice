#!groovy

COMMIT_ID = ""
APP_VERSION = ""

node {
stage 'Version'
echo "The current version is: " + version()
}

def version() {
    def matcher = readFile('gradle.properties') =~ 'version=(.+)-.*'
    matcher ? matcher[0][1].tokenize(".") : null
}