#!groovy

stage 'Semantic Version'
timeout(time: 1, unit: 'DAYS') {
    input message: 'Determine semantic version?',
    parameters: [[$class: 'ChoiceParameterDefinition',
                  choices: 'patch\nminor\nmajor',
                  description: 'Semantic version segment to update',
                  name: 'SEMANTIC_VERSION_SEGMENT']]

    def buildNumber = env.BUILD_NUMBER

    def result2 = env.SEMANTIC_VERSION_SEGMENT
    echo "result2: " + result2 + ", build number: " + buildNumber
}