#!groovy

COMMIT_ID = ""
APP_VERSION = ""

node {
stage 'Version'

    def props = new Properties()
    new File("gradle.properties").withInputStream {
      stream -> props.load(stream)
    }

    echo "1 - The current version is: " + props["version"]
}

def version() {

}