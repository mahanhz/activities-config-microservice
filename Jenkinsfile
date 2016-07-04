#!groovy

stage 'Semantic Version'
timeout(time: 1, unit: 'DAYS') {
    input message: 'Determine semantic version?',
    parameters: [[$class: 'ChoiceParameterDefinition',
                  choices: 'patch\nminor\nmajor',
                  description: 'Semantic version segment to update',
                  name: 'SEMANTIC_VERSION_SEGMENT']]

    def result2 = $SEMANTIC_VERSION_SEGMENT
    echo "result2: " + result2
    def result3 = ${SEMANTIC_VERSION_SEGMENT}
    echo "result3: " + result3
}