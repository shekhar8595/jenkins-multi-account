pipeline {
    agent any

    parameters {
        choice(
            name: 'ENV',
            choices: ['dev', 'uat', 'prod'],
            description: 'Select deployment environment'
        )
    }

    stages {
        stage('Checkout') {
            steps {
                git branch: 'main', url: 'https://github.com/shekhar8595/jenkins-multi-account.git'
            }
        }

        stage('Terraform Init & Plan') {
            steps {
                script {
                    def modulePath = "modules/vm"
                    def envFolder = "environment/${params.ENV}"

                    echo "Initializing Terraform for ${params.ENV}"
                    sh "cd ${modulePath} && terraform init -input=false -backend-config=${envFolder}/backend.tfvars"

                    echo "Planning Terraform deployment"
                    sh "cd ${modulePath} && terraform plan -var-file=${envFolder}/terraform.tfvars"
                }
            }
        }

        stage('Terraform Apply') {
            steps {
                script {
                    def modulePath = "modules/vm"
                    def envFolder = "environment/${params.ENV}"

                    echo "Applying Terraform configuration for ${params.ENV}"
                    sh "cd ${modulePath} && terraform apply -auto-approve -var-file=${envFolder}/terraform.tfvars"
                }
            }
        }
    }

    post {
        success {
            echo "Terraform deployment for ${params.ENV} succeeded!"
        }
        failure {
            echo "Terraform deployment for ${params.ENV} failed!"
        }
    }
}
