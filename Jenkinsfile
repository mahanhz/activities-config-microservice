stage 'Build'
node {
    checkout scm

    sh './gradlew clean build'
}

// Obtaining commit id like this until JENKINS-26100 is implemented
// See http://stackoverflow.com/questions/36304208/jenkins-workflow-checkout-accessing-branch-name-and-git-commit
sh 'git rev-parse HEAD > commit'
def commit_id = readFile('commit').trim()

def app_version = readFile("version.txt").trim()

stage 'Integration test'
node {
    echo "Commit id:" + commit_id + "and version: " + app_version
}
