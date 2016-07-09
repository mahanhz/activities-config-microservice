#!groovy

COMMIT_ID = ""
RELEASE_VERSION = ""
SELECTED_SEMANTIC_VERSION_UPDATE = ""

echo "branch: " + env.BRANCH_NAME

stage 'Build'
node {
    checkout scm

    sh './gradlew clean build'

    stash excludes: 'build/', includes: '**', name: 'commitSource'

    // Obtaining commit id like this until JENKINS-26100 is implemented
    // See http://stackoverflow.com/questions/36304208/jenkins-workflow-checkout-accessing-branch-name-and-git-commit
    sh 'git rev-parse HEAD > commit'
    COMMIT_ID = readFile('commit').trim()

    RELEASE_VERSION = releaseVersion()
}

stage 'Integration test'
node {
    unstash 'commitSource'
    sh 'chmod 755 gradlew'
    sh './gradlew integrationTest'
}

stage name: 'Merge', concurrency: 1
node {
    checkout changelog: false,
             poll: false,
             scm: [$class: 'GitSCM',
                   branches: [[name: '*/master']],
                   doGenerateSubmoduleConfigurations: false,
                   extensions: [[$class: 'LocalBranch', localBranch: 'master'], [$class: 'WipeWorkspace']],
                   submoduleCfg: [],
                   userRemoteConfigs: [[url: 'git@github.com:mahanhz/activities-config-microservice.git']]]

    sh "git merge ${COMMIT_ID}"
    sh "git push origin master"

    stash excludes: 'build/', includes: '**', name: 'snapshotMasterSource'
    stash excludes: 'build/, .gradle/', includes: '**', name: 'releaseMasterSource'
}

stage name: 'Publish snapshot', concurrency: 1
node {
    unstash 'snapshotMasterSource'
    sh 'chmod 755 gradlew'
    sh './gradlew build uploadArchives -x test'
}

stage 'Approve RC?'
timeout(time: 1, unit: 'DAYS') {
    def descr = "If unchanged released version will be: " + RELEASE_VERSION

    SELECTED_SEMANTIC_VERSION_UPDATE =
            input message: 'Publish release candidate?',
                    parameters: [[$class: 'ChoiceParameterDefinition',
                                  choices: 'unchanged\nmajor\nminor\npatch',
                                  description: descr,
                                  name: '']]
}

stage name: 'Publish RC', concurrency: 1
node {
    def script = "scripts/release/activities_config_release.sh"

    unstash 'releaseMasterSource'
    sh 'chmod 755 gradlew'
    sh "chmod 755 " + script
    sh "./" + script + " ${RELEASE_VERSION} ${SELECTED_SEMANTIC_VERSION_UPDATE}"
}

def releaseVersion() {
    def props = readProperties file: 'gradle.properties'
    def version = props['version']

    if (version.contains('-SNAPSHOT')) {
        version = version.replaceFirst('-SNAPSHOT', '')
    }

    return version
}