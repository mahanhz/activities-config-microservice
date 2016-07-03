#!groovy

COMMIT_ID = ""
APP_VERSION = ""

node {
stage 'Version'
def originalV = version();
echo "1 - The current version is: " + originalV
echo "2 - The current version is: " + originalV[0]
}

def version() {
    def matcher = readFile('gradle.properties') =~ 'version=(.+)-.*'
    matcher ? matcher[0][1].tokenize(".") : null
}