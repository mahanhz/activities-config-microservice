#!groovy

stage 'Semantic Version'
timeout(time: 1, unit: 'DAYS') {
    result = input message: 'Determine semantic version?',
    parameters: [[$class: 'ChoiceParameterDefinition',
                  choices: 'patch\nminor\nmajor',
                  description: 'Semantic version segment to update',
                  name: 'SEMANTIC_VERSION_SEGMENT']]

    def buildNumber = env.BUILD_NUMBER

    echo "result: " + result + ", build number: " + buildNumber
}