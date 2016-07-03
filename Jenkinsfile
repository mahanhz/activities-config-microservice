#!groovy

COMMIT_ID = ""
APP_VERSION = ""

node {
stage 'Version'
def originalV = version();
echo "1 - The current version is: " + originalV
}

def version() {
    def matcher = readFile('gradle.properties')
    matcher.replaceFirst('version=', '')
}