#!groovy

COMMIT_ID = ""

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

/*stage 'Integration test'
node {
    unstash 'source'
    sh 'chmod 755 gradlew'
    sh './gradlew integrationTest'
}*/

stage name: 'Merge', concurrency: 1
node {
    build job: 'Activities-config-merge', parameters: [[$class: 'GitParameterValue', name: 'GIT_COMMIT_ID', value: COMMIT_ID]]
}

/*stage name: 'Publish snapshot', concurrency: 1
node {
    unstash 'source'
    sh 'chmod 755 gradlew'
    sh './gradlew build uploadArchives'
}*/

stage 'Approve RC?'
timeout(time: 1, unit: 'DAYS') {
    input message: 'Publish release candidate?'
}

stage 'Publish release candidate'
node {
    input message: 'Determine semantic version?',
    parameters: [[$class: 'ChoiceParameterDefinition',
                  choices: 'patch\nminor\nmajor',
                  description: 'Semantic version segment to update',
                  name: 'SEMANTIC_VERSION_SEGMENT']]

    def currentVersion = version()
    build job: 'Activities-config-publish-release',
                  parameters: [[$class: 'StringParameterValue', name: 'CURRENT_VERSION', value: currentVersion]]
}

def version() {
    def matcher = readFile('gradle.properties')
    matcher.replaceFirst('version=', '')
}