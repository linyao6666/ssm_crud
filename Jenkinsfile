pipeline {
  agent any
  stages {
    stage('Testing') {
      steps {
        sh '''bat "mvn test"
junit \'target/surefire-reports/TEST-*.xml\''''
      }
    }
  }
}