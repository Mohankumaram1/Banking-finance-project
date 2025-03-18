

pipeline {
  agent any

  tools {
    maven 'M2_HOME'
  }

  stages {
    stage('CheckOut') {
      steps {
        echo 'Checkout the source code from GitHub'
        git branch: 'main', url: 'https://github.com/Mohankumaram1/banking-finance-project.git'
      }
    }
      stage('Package the Application') {
      steps {
        echo " Packaing the Application"
        sh 'mvn clean package'
            }
    }
   stage('Docker Image Creation') {
      steps {
        sh 'docker build -t mohankumar12/bankingfinance:3.0 .'
            }
    }
     stage('DockerLogin') {
      steps {
        withCredentials([usernamePassword(credentialsId: 'Docker-Login', passwordVariable: 'docker_password', usernameVariable: 'docker_login')]) {
        sh "docker login -u ${docker_login} -p ${docker_password}"
            }
        }
    } 
   stage('Push Image to DockerHub') {
      steps {
        sh 'docker push mohankumar12/bankingfinance:3.0'
            }
   }
    
    stage ('Configure Test-server with Terraform, Ansible and then Deploying') {
      steps {
        dir('my-serverfiles') {
          sh 'chmod 600 mohanm.pem'
          sh 'terraform init'
          sh 'terraform validate'
          sh 'terraform apply --auto-approve'
        }

                   
       }
     }  
   } 
  }
  
