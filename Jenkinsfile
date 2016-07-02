node {
    checkout scm

    // Obtaining commit id like this until JENKINS-26100 is implemented
    // See http://stackoverflow.com/questions/36304208/jenkins-workflow-checkout-accessing-branch-name-and-git-commit
    sh 'git rev-parse HEAD > commit'
    def commit_id = readFile('commit').trim()

    stage 'Tag'
        echo 'About to create tag: v${version}-b${env.BUILD_NUMBER}-t${env.BUILD_TIMESTAMP}'
        sh 'git tag -a v1.0.0-b1-t1 -m "Release test"'
        sh 'git push --tags'

}