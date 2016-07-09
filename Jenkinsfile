#!groovy

COMMIT_ID = ""
RELEASE_VERSION = ""
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

    RELEASE_VERSION = releaseVersion()
}

if (!isMasterBranch()) {


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
        checkout scm: [$class: 'GitSCM',
                       branches: [[name: '*/master']],
                       doGenerateSubmoduleConfigurations: false,
                       extensions: [[$class: 'LocalBranch', localBranch: 'master'], [$class: 'WipeWorkspace']],
                       submoduleCfg: [],
                       userRemoteConfigs: [[url: 'git@github.com:mahanhz/activities-config-microservice.git']]]

        sh "git branch -a -v --no-abbrev"
        sh "git checkout -b release " + COMMIT_ID
        sh "./scripts/release/activities_config_release.sh ${RELEASE_VERSION} ${SELECTED_SEMANTIC_VERSION_UPDATE}"
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