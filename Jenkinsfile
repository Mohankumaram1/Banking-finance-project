
pipeline {
  agent any

  stages {
    stage('CheckOut') {
      steps {
        echo 'Checkout the source code from GitHub'
        git branch: 'main', url: 'https://github.com/Mohankumaram1/Banking-finance-project.git'
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
        sh 'sleep 30'
      }
    }

    stage ('Deploy Application') {
      steps {
        sh 'kubectl apply -f deploymentservice.yml'
      }
    }
  }  // Closing `stages` block
}  // Closing `pipeline` block
