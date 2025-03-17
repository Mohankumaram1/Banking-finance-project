
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
      }
    }
       stage('Deploy to k8s'){
            steps{
                script{
                     kubernetesDeploy (configs: 'deploymentservice.yaml' ,kubeconfigId: 'kubernetesconf')
                   
       }
     }  
   } 
  }
}
