pipeline {
    agent any
    options {
        buildDiscarder(logRotator(numToKeepStr: '5'))
        disableConcurrentBuilds()
    }
    stages{
        stage('Hello World') {
            steps {
              sh echo "Hello World!"
            }
        }
    }
}

