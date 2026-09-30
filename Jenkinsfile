pipeline {
    agent any

    environment {
        AWS_DEFAULT_REGION = 'ap-south-1'
    }

    stages {
        stage('AWS Authentication') {
            steps {
                withCredentials([[
                    $class: 'AmazonWebServicesCredentialsBinding',
                    credentialsId: 'aws-terraform-creds'
                ]]) {
                    sh 'aws sts get-caller-identity'
                }
            }
        }

        stage('Terraform Init') {
            steps {
                dir('/var/lib/jenkins/jenkins-terraform-aws/terraform') {
                    withCredentials([[
                        $class: 'AmazonWebServicesCredentialsBinding',
                        credentialsId: 'aws-terraform-creds'
                    ]]) {
                        sh 'terraform init'
                    }
                }
            }
        }

        stage('Terraform Validate') {
            steps {
                dir('/var/lib/jenkins/jenkins-terraform-aws/terraform') {
                    sh 'terraform fmt -check -recursive'
                    sh 'terraform validate'
                }
            }
        }

        stage('Terraform Plan') {
            steps {
                dir('/var/lib/jenkins/jenkins-terraform-aws/terraform') {
                    withCredentials([[
                        $class: 'AmazonWebServicesCredentialsBinding',
                        credentialsId: 'aws-terraform-creds'
                    ]]) {
                        sh 'terraform plan -out=tfplan'
                    }
                }
            }
        }

        stage('Approval') {
            steps {
                input message: 'Approve Terraform deployment?'
            }
        }

        stage('Terraform Apply') {
            steps {
                dir('/var/lib/jenkins/jenkins-terraform-aws/terraform') {
                    withCredentials([[
                        $class: 'AmazonWebServicesCredentialsBinding',
                        credentialsId: 'aws-terraform-creds'
                    ]]) {
                        sh 'terraform apply -auto-approve tfplan'
                    }
                }
            }
        }
    }
}
