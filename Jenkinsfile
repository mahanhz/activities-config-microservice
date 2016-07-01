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

    stage 'Merge'
    build job: 'activities-config-microservice-merge', parameters: [[$class: 'GitParameterValue', name: 'GIT_COMMIT_ID', value: commit_id]]

    stage 'Publish snapshot'
    sh './gradlew build uploadArchives'
}