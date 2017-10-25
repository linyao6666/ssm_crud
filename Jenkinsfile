pipeline {
  agent any
  stages {
    stage('Testing') {
      steps {
        script {
          node{
            stage("hehe"){
              git "https://github.com/linyao6666/ssm_crud"
              bat "mvn -version"
              bat "mvn clean"
              bat "mvn compile"
            }
          }
        }
        
      }
    }
  }
}