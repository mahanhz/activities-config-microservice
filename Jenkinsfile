COMMIT_ID = ""
APP_VERSION = ""

stage 'Build'
node {
    checkout scm

    sh './gradlew clean build'

    // Obtaining commit id like this until JENKINS-26100 is implemented
    // See http://stackoverflow.com/questions/36304208/jenkins-workflow-checkout-accessing-branch-name-and-git-commit
    sh 'git rev-parse HEAD > commit'
    COMMIT_ID = readFile('commit').trim()

    APP_VERSION = readFile("version.txt").trim()
}

stage 'Integration test'
node {
    echo "Commit id:" + COMMIT_ID + "and version: " + APP_VERSION
}
