node {
    checkout scm

    // Obtaining commit id like this until JENKINS-26100 is implemented
    // See http://stackoverflow.com/questions/36304208/jenkins-workflow-checkout-accessing-branch-name-and-git-commit
    sh 'git rev-parse HEAD > commit'
    def commit_id = readFile('commit').trim()

    def app_version = readFile("version.txt").trim()

    stage 'Tag'
        build job: 'Activities-config-tag-release',
                      parameters: [[$class: 'GitParameterValue', name: 'GIT_COMMIT_ID', value: commit_id],
                                   [$class: 'StringParameterValue', name: 'APP_VERSION', value: app_version]]

}