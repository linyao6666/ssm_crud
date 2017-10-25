pipeline {
  agent any
  stages {
    stage('Building') {
      steps {
        sh '''sh "mvn clean"
sh "infer -- mvn compile"'''
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