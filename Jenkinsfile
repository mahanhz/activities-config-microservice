#!groovy

COMMIT_ID = ""
SELECTED_SEMANTIC_VERSION_SEGMENT = "patch"

stage 'Semantic Version'
timeout(time: 1, unit: 'DAYS') {
    SELECTED_SEMANTIC_VERSION_SEGMENT =
    input message: 'Determine semantic version?',
    parameters: [[$class: 'ChoiceParameterDefinition',
                  choices: 'patch\nminor\nmajor',
                  description: 'Semantic version segment to update',
                  name: 'SEMANTIC_VERSION_SEGMENT']]

    def buildNumber = env.BUILD_NUMBER

    echo "SELECTED_SEMANTIC_VERSION_SEGMENT: " + SELECTED_SEMANTIC_VERSION_SEGMENT + ", build number: " + buildNumber
}


stage 'Build'
node {

    echo "Now inside build node - SELECTED_SEMANTIC_VERSION_SEGMENT: " + SELECTED_SEMANTIC_VERSION_SEGMENT
}