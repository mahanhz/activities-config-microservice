#!groovy

COMMIT_ID = ""
SELECTED_SEMANTIC_VERSION_UPDATE = ""

stage 'Build'
node {
    checkout scm

    sh './gradlew clean build'

    stash excludes: 'build/', includes: '**', name: 'source'

    // Obtaining commit id like this until JENKINS-26100 is implemented
    // See http://stackoverflow.com/questions/36304208/jenkins-workflow-checkout-accessing-branch-name-and-git-commit
    sh 'git rev-parse HEAD > commit'
    COMMIT_ID = readFile('commit').trim()
}

stage 'Integration test'
node {
    unstash 'source'
    sh 'chmod 755 gradlew'
    sh './gradlew integrationTest'
}

stage name: 'Merge', concurrency: 1
node {
    build job: 'Activities-config-merge', parameters: [[$class: 'GitParameterValue', name: 'GIT_COMMIT_ID', value: COMMIT_ID]]
}

stage name: 'Publish snapshot', concurrency: 1
node {
    unstash 'source'
    sh 'chmod 755 gradlew'
    sh './gradlew build snapshot uploadArchives -x test'
}

stage 'Approve RC?'
timeout(time: 1, unit: 'DAYS') {
    SELECTED_SEMANTIC_VERSION_UPDATE =
            input message: 'Publish release candidate?',
                    parameters: [[$class: 'ChoiceParameterDefinition',
                                  choices: 'unchanged\nmajor\nminor\npatch',
                                  description: 'Semantic version update',
                                  name: 'Semantic version for this release']]
}

stage name: 'Publish RC', concurrency: 1
node {
    def currentVersion = version()
    build job: 'Activities-config-publish-release',
            parameters: [[$class: 'StringParameterValue', name: 'CURRENT_VERSION', value: currentVersion],
                         [$class: 'StringParameterValue', name: 'SEMANTIC_VERSION_UPDATE', value: SELECTED_SEMANTIC_VERSION_UPDATE]]
}

def version() {
    def props = readProperties file: 'gradle.properties'
    return props['version']
}