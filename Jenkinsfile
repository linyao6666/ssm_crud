pipeline {
  agent any
  stages {
    stage('Building') {
      steps {
        sh '''bat "mvn clean"
bat "infer -- mvn compile"'''
      }
    }
    stage('Testing') {
      steps {
        sh '''bat "mvn test"
junit \'target/surefire-reports/TEST-*.xml\''''
      }
    }
  }
}