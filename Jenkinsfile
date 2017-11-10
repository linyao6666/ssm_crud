pipeline {
  agent any
  stages {
    stage('Testing') {
      steps {
        script {
          node{
            stage("hehe"){
              bat "mvn -version"
              bat "mvn clean"
              bat "mvn test"
            }
          }
        }
        
      }
    }
  }
}