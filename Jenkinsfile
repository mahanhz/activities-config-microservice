node {
    checkout scm

    // Obtaining commit id like this until JENKINS-26100 is implemented
    // See http://stackoverflow.com/questions/36304208/jenkins-workflow-checkout-accessing-branch-name-and-git-commit
    sh 'git rev-parse HEAD > commit'
    def commit_id = readFile('commit').trim()

    stage 'Build'
        sh './gradlew clean build'

    stage 'Integration test'
        sh './gradlew integrationTest'

    stage name: 'Merge', concurrency: 1
        build job: 'Activities-config-merge', parameters: [[$class: 'GitParameterValue', name: 'GIT_COMMIT_ID', value: commit_id]]

    stage name: 'Publish snapshot', concurrency: 1
        sh './gradlew uploadArchives'

    // stage name: 'Deploy snapshot', concurrency: 1
    // input 'Deploy snapshot?'
    // sh './gradlew deployToProduction -PrepoId=snapshots -PartifactVersion=LATEST'

    stage 'Publish release candidate'
        timeout(time: 1, unit: 'DAYS') {
            input 'Publish release candidate?'
            sh './gradlew clean build release uploadArchives -x test'
            echo 'About to create tag: v${version}-b${env.BUILD_NUMBER}-t${env.BUILD_TIMESTAMP}'
            sh 'git tag -a v${version}-b${env.BUILD_NUMBER}-t${env.BUILD_TIMESTAMP} -m "Release v${version}-b${env.BUILD_NUMBER}-t${env.BUILD_TIMESTAMP}"'
            sh 'git push --tags'
        }

    // stage name: 'Deploy release', concurrency: 1
    // input 'Deploy release?'
    // sh './gradlew deployToProduction -PrepoId=releases -PartifactVersion=RELEASE'
}