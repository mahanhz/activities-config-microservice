#!groovy

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
    sh './gradlew integrationTest'
}

stage name: 'Merge', concurrency: 1
node {
    build job: 'Activities-config-merge', parameters: [[$class: 'GitParameterValue', name: 'GIT_COMMIT_ID', value: COMMIT_ID]]
}

stage name: 'Publish snapshot', concurrency: 1
node {
    sh './gradlew build uploadArchives'
}

stage 'Approve RC?'
timeout(time: 1, unit: 'DAYS') {
    input message: 'Publish release candidate?'
}

stage 'Publish release candidate'
node {
    sh './gradlew clean build release uploadArchives -x test'

    build job: 'Activities-config-tag-release',
                  parameters: [[$class: 'GitParameterValue', name: 'GIT_COMMIT_ID', value: COMMIT_ID],
                               [$class: 'StringParameterValue', name: 'APP_VERSION', value: APP_VERSION]]
}

// stage name: 'Deploy release', concurrency: 1
// input 'Deploy release?'
// sh './gradlew deployToProduction -PrepoId=releases -PartifactVersion=RELEASE'
