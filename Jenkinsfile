#!groovy

COMMIT_ID = ""
FALLBACK_RELEASE_VERSION = ""
SELECTED_SEMANTIC_VERSION_UPDATE = ""
NUMBER_OF_BUILD_TO_KEEP = "5"

properties([[$class: 'BuildDiscarderProperty', strategy:
            [$class: 'LogRotator', artifactDaysToKeepStr: '',
             artifactNumToKeepStr: '', daysToKeepStr: '', numToKeepStr: NUMBER_OF_BUILD_TO_KEEP]],
            [$class: 'ThrottleJobProperty', categories: [], limitOneJobWithMatchingParams: false,
             maxConcurrentPerNode: 0, maxConcurrentTotal: 0, paramsToUseForLimit: '',
             throttleEnabled: false, throttleOption: 'project']])

stage 'Build'
node {
    checkout scm

    sh './gradlew clean build'

    stash excludes: 'build/', includes: '**', name: 'source'

    // Obtaining commit id like this until JENKINS-26100 is implemented
    // See http://stackoverflow.com/questions/36304208/jenkins-workflow-checkout-accessing-branch-name-and-git-commit
    sh 'git rev-parse HEAD > commit'
    COMMIT_ID = readFile('commit').trim()

    FALLBACK_RELEASE_VERSION = releaseVersion()
}

if (!isMasterBranch()) {
    stage 'Integration test'
    node {
        unstash 'source'
        sh 'chmod 755 gradlew'
        sh './gradlew integrationTest'
    }

    stage name: 'Merge', concurrency: 1
    node {
        checkout scm: [$class: 'GitSCM',
                       branches: [[name: '*/master']],
                       doGenerateSubmoduleConfigurations: false,
                       extensions: [[$class: 'LocalBranch', localBranch: 'master'], [$class: 'WipeWorkspace']],
                       submoduleCfg: [],
                       userRemoteConfigs: [[url: 'git@github.com:mahanhz/activities-config-microservice.git']]]

        sh "git merge ${COMMIT_ID}"
        sh "git push origin master"
    }
}

if (isMasterBranch()) {
    stage name: 'Publish snapshot', concurrency: 1
    node {
        unstash 'source'
        sh 'chmod 755 gradlew'
        sh './gradlew build uploadArchives -x test'
    }

    stage 'Approve RC?'
    timeout(time: 1, unit: 'DAYS') {
        SELECTED_SEMANTIC_VERSION_UPDATE =
                input message: 'Publish release candidate?',
                        parameters: [[$class: 'ChoiceParameterDefinition',
                                      choices: 'patch\nminor\nmajor',
                                      description: 'Determine the semantic version to release',
                                      name: '']]
    }

    stage name: 'Publish RC', concurrency: 1
    node {
        sh "git branch -a -v --no-abbrev"

        checkout scm: [$class: 'GitSCM',
                       branches: [[name: '*/master']],
                       doGenerateSubmoduleConfigurations: false,
                       extensions: [[$class: 'LocalBranch', localBranch: 'master'], [$class: 'WipeWorkspace']],
                       submoduleCfg: [],
                       userRemoteConfigs: [[url: 'git@github.com:mahanhz/activities-config-microservice.git']]]

        stash includes: 'gradle.properties', name: 'masterProperties'

        unstash 'source'
        unstash 'masterProperties'

        def script = "scripts/release/activities_config_release.sh"
        sh "chmod 755 " + script
        sh 'chmod 755 gradlew'

        sh "./" + script + " ${SELECTED_SEMANTIC_VERSION_UPDATE} ${FALLBACK_RELEASE_VERSION}"
    }
}

def releaseVersion() {
    def props = readProperties file: 'gradle.properties'
    def version = props['version']

    if (version.contains('-SNAPSHOT')) {
        version = version.replaceFirst('-SNAPSHOT', '')
    }

    return version
}

def isMasterBranch() {
    return env.BRANCH_NAME == "master"
}