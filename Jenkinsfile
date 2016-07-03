#!groovy

COMMIT_ID = ""
APP_VERSION = version()

stage 'Version'
echo "The current version is: " + APP_VERSION

def version() {
    def matcher = readFile('gradle.properties') =~ 'version=(.+)-.*'
    matcher ? matcher[0][1].tokenize(".") : null
}